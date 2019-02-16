
-- Effects manager, main file
-- Select between multiple voice effects, and enjoy ~

with Gesture_Manager;      pragma Unreferenced (Gesture_Manager);
with System;

with STM32.Board;          use STM32.Board;
with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);

--with STM32.Device;         --use STM32.Device;

use System;
--with STM32.Timers;         use STM32.Timers;
with HAL.Audio;            use HAL.Audio;

with ADC_Interrupt_Handling; use ADC_Interrupt_Handling;
with Ada.Synchronous_Task_Control;  use Ada.Synchronous_Task_Control;

with STM32F4_Timer_Interrupts;  pragma Unreferenced (STM32F4_Timer_Interrupts);
with HAL;                  use HAL;
with ILI9341_Extended;     use ILI9341_Extended;
with Audio_Stream;         use Audio_Stream;
with Custom_Board; use Custom_Board;

-- Project files used

procedure Main is
   -- Main priority for this task
   pragma Priority (System.Priority'First);

   -- Audio buffer variables
   -- Use the size of buffer defined in custom_board.ads
--     Audio_Data_0 : Audio_Buffer (1 .. buffer_size*2) := (others => 0);
--     Audio_Data_1 : Audio_Buffer (1 .. buffer_size*2) := (others => 0);
   Stereo_Data : Audio_Buffer(1 .. buffer_size*2);
   Processed_Data : Audio_Buffer(1 .. buffer_size);

begin
   Initialize_LEDs;
   -- Initalize I2C (gesture and DAC control) + I2S audio
   Initialize_Audio;

   -- Configure adc module
   Initialize_ADC;

   -- Configure DAC DMA
   --STM32.Board.Audio_DAC.Set_Volume (50);
   --STM32.Board.Audio_DAC.Play;

   -- Initialize timer variables that acquire adc data
   Initialize_Timer;
   -- Initialize SPI
   Initialize_SPI;

   -- Initialize ILI9341 screen
   Initialize(This => Screen, Mode => ILI9341_Extended.SPI_Mode);
   Screen.Set_Orientation(To   => Landscape_1);
   Screen.Set_Font(Font => Large_Font);
   HAL_Time.Delay_Microseconds(10);
   Fill(This  => Screen,
        Color => Black);

   -- Initialize gesture sensor
   Initialize_Gesture_Sensing;

   -- Start the DMA function to send samples to DAC
   Audio_TX_DMA_Int.Start (Destination => STM32.Board.Audio_I2S.Data_Register_Address,
                           Source_0    => Audio_Data_0'Address,
                           Source_1    => Audio_Data_1'Address,
                           Data_Count  => Audio_Data_0'Length);

   -- Wait for the first dma transfer complete before starting processing the
   -- adc samples
   --Audio_TX_DMA_Int.Wait_For_Transfer_Complete;

   -- Enable timer7, to start reading samples from adc
   --Enable (Timer_7);

   -- Notify the second task, that init of modules was completed
   Set_True(Finished_Init);

   loop
      -- Suspend until a new set of ADC samples is ready
      Suspend_Until_True(Completed_Set_Samples);

      -- Save a copy of the array of adc values
      Processed_Data := Samples_Buffer;

      -- Use the current selected effect
      if (current_effect = 0) then
         First_Effect.Process_Audio_Block(Samples_To_Process => Processed_Data);
      elsif(current_effect = 1) then
         Second_Effect.Process_Audio_Block(Samples_To_Process => Processed_Data);
      elsif(current_effect = 2) then
         Third_Effect.Process_Audio_Block(Samples_To_Process => Processed_Data);
      elsif(current_effect = 3) then
         Fourth_Effect.Process_Audio_Block(Samples_To_Process => Processed_Data);
      elsif(current_effect = 4) then
         Fifth_Effect.Process_Audio_Block(Samples_To_Process => Processed_Data);
      else
         -- Raise an exception
         raise Program_Error with "Not defined effect for this value";
      end if;

      -- Convert the MONO signal to Stereo
      --for Index in Processed_Data'Range loop
      for Index in Processed_Data'Range loop
         Stereo_Data ((Index * 2) -1 ) := Processed_Data(Index);
         Stereo_Data ((Index * 2) ) := Processed_Data(Index);
      end loop;

      -- Help sync the dma transfers
      Audio_TX_DMA_Int.Wait_For_Transfer_Complete;

      -- Send the new set of data to the DAC
      if Audio_TX_DMA_Int.Not_In_Transfer = Audio_Data_0'Address then
         Audio_Data_0 := Stereo_Data;
      else
         Audio_Data_1 := Stereo_Data;
      end if;
   end loop;

end Main;

