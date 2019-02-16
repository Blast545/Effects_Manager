with STM32.Device; use STM32.Device;
with STM32.GPIO; use STM32.GPIO;
with STM32.ADC; use STM32.ADC;
with ILI9341_Extended; use ILI9341_Extended;
with Ravenscar_Time; --use Ravenscar_Time;
with HAL; --use HAL;
with HAL.Time;
with Ada.Synchronous_Task_Control;  use Ada.Synchronous_Task_Control;
with apds9960_gesture; use apds9960_gesture;
with STM32.Board; use STM32.Board;


-- Effects used:
with Almost_Raw;
with Only_Voice; --use Only_Voice;
with Echo;
with Pitch;
with Robot;
with HAL.Audio; use HAL.Audio;
with STM32.Timers; use STM32.Timers;

-- This file provides declarations for objects used in the main program
-- Initializing the modules in an additional file, allows to use procedures
-- globally in other modules (for example, showing a message to the screen
-- when a last_chance_handler condition occurs)

package Custom_Board is
   pragma Elaborate_Body;

   Sampling_Timer : Timer renames Timer_7;

   -- Suspension object, do not gesture manager until system variables
   -- were started in the main file
   Finished_Init : Suspension_Object; --
   -- Use this to start second task
   Finished_Init_Gesture : Suspension_Object;

   -- Buffer size, used for effects and mic acquisition
   buffer_size : constant Natural := 256;
   Audio_Data_0 : Audio_Buffer (1 .. buffer_size*2) := (others => 0);
   Audio_Data_1 : Audio_Buffer (1 .. buffer_size*2) := (others => 0);

   -- Effects objects
   First_Effect : Almost_Raw.Almost_Raw_Effect;
   Second_Effect : Only_Voice.Only_Voice_Effect;
   Third_Effect : Echo.Echo_Effect;
   Fourth_Effect: Pitch.Pitch_Effect;
   Fifth_Effect: Robot.Robot_Effect;
   Current_Name : String := Almost_Raw.Effect_Name;

   type effect_index is mod 5;
   current_effect : effect_index := effect_index'First;

   -- ravenscar time delay
   HAL_Time  : constant HAL.Time.Any_Delays := Ravenscar_Time.Delays;

   -- ADC Variables
   -- ADC 2, IN8, mapped to port PB0
   VMic_Channel : constant Analog_Input_Channel := 8;
   VMic : constant ADC_Point := (ADC_2'Access, Channel => VMic_Channel);

   MIC_GPIO  : GPIO_Point renames PB0;
   MIC_CONF  : constant GPIO_Port_Configuration := (Mode => Mode_Analog, Resistors => Floating);
   ADC_USED : Analog_To_Digital_Converter renames ADC_2;
   All_Regular_Conversions : constant Regular_Channel_Conversions :=
     (1 => (Channel => VMic.Channel, Sample_Time => Sample_15_Cycles));

   -- Screen variables
   Screen : ILI9341_Device(Port => SPI_1'Access,
                           Chip_Select => PA1'Access,
                           WRX => PA2'Access,
                           Reset => PA3'Access,
                           Time => HAL_Time);
   SPI1_SCK     : GPIO_Point renames PA5;
   SPI1_MISO    : GPIO_Point renames PA6;
   SPI1_MOSI    : GPIO_Point renames PA7;

   -- Gesture variables
   -- apds object
   Gesture_Object : APDS9960_Device(Port => Audio_I2C'Access,
                                    Time => HAL_Time);
   Gesture_Int_Pin    : GPIO_Point renames PB1;

   procedure Initialize_ADC;
   procedure Initialize_Timer;
   procedure Initialize_SPI;
   procedure Initialize_Gesture_Sensing;

end Custom_Board;
