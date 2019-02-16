--  with STM32.GPIO;           use STM32.GPIO;
--  with STM32.I2C; use STM32.I2C;
--  with STM32.ADC;            use STM32.ADC;
--  with HAL.Time;
--  with STM32.SPI; use STM32.SPI;

-- Package body
--with STM32.Timers;
with HAL.SPI;
with STM32.SPI; use STM32.SPI;
with STM32.EXTI; use STM32.EXTI;

package body Custom_Board is

   procedure Initialize_ADC is
   begin
      -- Initialize the GPIO port used for Analog input (PB0)
      Enable_Clock (GPIO_B);
      Configure_IO (MIC_GPIO, MIC_CONF);
      Enable_Clock(ADC_USED);

      -- Initialize ADC module for the used ADC
      Configure_Common_Properties
        (Mode           => Independent,
         Prescalar      => PCLK2_Div_2,
         DMA_Mode       => Disabled,
         Sampling_Delay => Sampling_Delay_5_Cycles);

      Configure_Unit
        (VMic.ADC.all,
         Resolution => ADC_Resolution_12_Bits,
         Alignment  => Right_Aligned);

      Configure_Regular_Conversions
        (VMic.ADC.all,
         Continuous  => False,
         Trigger     => Software_Triggered,
         Enable_EOC  => True,
         Conversions => All_Regular_Conversions);

      Enable_Interrupts (VMic.ADC.all, Regular_Channel_Conversion_Complete);
      Enable (VMic.ADC.all);
   end Initialize_ADC;

   procedure Initialize_Timer is
   begin
      Enable_Clock (Timer_7);
      Reset (Timer_7);
      -- Period defines the number of counts, prescaler divides the clock
      -- APB1 := 84 Mhz, Desired freq := APB1/Desired_sample rate
      -- Sample rate := 48khz, Period := 1750 @ Prescaler := 0
      Configure (Timer_7, Prescaler => 0, Period => 1750);
      Enable_Interrupt (Timer_7, Timer_Update_Interrupt);
      --Enable (Timer_7);
   end Initialize_Timer;

   procedure Initialize_SPI is
   begin
      -- Initalize SPI clocks and GPIO
      Init_SPI_IO_Pins : declare
         Config : GPIO_Port_Configuration;
      begin
         Enable_Clock (GPIO_A);
         Enable_Clock (SPI_1);
         Enable_Clock (PA1 & PA2 & PA3 & SPI1_SCK & SPI1_MISO & SPI1_MOSI);


         Config := (Mode           => Mode_AF,
                    AF             => GPIO_AF_SPI1_5,
                    AF_Speed       => Speed_50MHz,
                    AF_Output_Type => Push_Pull,
                    Resistors      => Floating);

         Configure_IO (SPI1_SCK & SPI1_MISO & SPI1_MOSI, Config);
         Reset(SPI_1);
      end Init_SPI_IO_Pins;
      Init_SPI_Port : declare
         Config : SPI_Configuration;
      begin
         Config :=
           (Direction           => D2Lines_FullDuplex,
            Mode                => Master,
            Data_Size           => HAL.SPI.Data_Size_8b,
            Clock_Polarity      => Low,
            Clock_Phase         => P1Edge,
            Slave_Management    => Software_Managed,
            Baud_Rate_Prescaler => BRP_32,
            First_Bit           => MSB,
            CRC_Poly            => 7);

         Configure (SPI_1, Config);

         STM32.SPI.Enable (SPI_1);
         --All_LEDs_On;
      end Init_SPI_Port;
      Init_Chip_Select : declare
         Config : GPIO_Port_Configuration;
      begin
         Config := (Mode        => Mode_Out,
                    Speed       => Speed_25MHz,
                    Output_Type => Push_Pull,
                    Resistors   => Floating);

         Configure_IO (PA1 & PA2 & PA3, Config);
      end Init_Chip_Select;

   end Initialize_SPI;

   procedure Initialize_Gesture_Sensing is
   begin
      -- I2C modules are init using the Initialize_Audio procedure
      -- Init gesture sensing interrupt
      Enable_Clock (Gesture_Int_Pin);
      Configure_IO (Gesture_Int_Pin, (Mode => Mode_In, Resistors => Pull_Up));
      Configure_Trigger (Gesture_Int_Pin, Interrupt_Falling_Edge);
   end Initialize_Gesture_Sensing;

end Custom_Board;
