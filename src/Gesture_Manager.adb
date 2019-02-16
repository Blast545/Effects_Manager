with Ada.Real_Time;     use Ada.Real_Time;

with Ada.Synchronous_Task_Control; use Ada.Synchronous_Task_Control;
with Custom_Board; use Custom_Board;
with apds9960_gesture; use apds9960_gesture;
with ILI9341_Extended; use ILI9341_Extended;
with Apds9960_Interrupts; use Apds9960_Interrupts;
with CS43L22; use CS43L22;
with STM32.Board; use STM32.Board;
with HAL; use HAL;
with STM32.Timers; use STM32.Timers;
with Almost_Raw;
with Only_Voice;
with Echo;
with Pitch;
with Robot;
with User_Button;

package body Gesture_Manager is

   -- Most variables used are defined in the custom_board package
   Last_Command : Time := Clock;
   Delay_Between_Commands : constant Time_Span := Milliseconds (700);
   read_gesture : Gesture := None;
   current_bg : Colors := Black;
   current_text: Colors := Yellow;
   audio_volume : Volume_Level := 80;
   curren_status_gesture : Boolean := True;


   procedure Put_String_Screen(Text : String);
   procedure Erase_String_Screen;
   procedure Fill_Screen_Left;
   procedure Fill_Screen_Right;
   procedure Draw_Current_Volume;
   procedure get_current_colors(effect_bg : out Colors; effect_text_color : out Colors);
   procedure Write_Current_Effect_Name;
   procedure Write_Ready;
   procedure Process_Effect_Transition(Direction : Gesture);
   procedure Draw_G_State;

   procedure Put_String_Screen(Text : String) is
   begin
      Screen.Print_String(X                => 50,
                          Y                => 70,
                          Text             => Text,
                          Foreground_Color => current_text,
                          Background_Color => current_bg);
   end Put_String_Screen;

   procedure Erase_String_Screen is
   begin
      Screen.Draw_Filled_Rectangle(X                => 0,
                                   Y                => 100,
                                   Width_In_Pixels  => 300,
                                   Height_In_Pixels => 40,
                                   Color            => current_bg);
   end Erase_String_Screen;

   procedure Fill_Screen_Left is
   begin
      for index in 0 .. (Device_Height-1) loop
         Screen.Draw_Ver_Line(X               => index,
                             Y                => 0,
                             Height_In_Pixels => Device_Width,
                             Color            => current_bg);
      end loop;
   end Fill_Screen_Left;

   procedure Fill_Screen_Right is
   begin
      for index in reverse 0 .. (Device_Height-1) loop
         Screen.Draw_Ver_Line(X               => index,
                              Y                => 0,
                              Height_In_Pixels => Device_Width,
                              Color            => current_bg);
      end loop;

   end Fill_Screen_Right;

   procedure Draw_Current_Volume
   is
      step_size : constant Natural := 10;
      y_base : constant Natural := 180;
      max_height : constant Natural := step_size*11;

      calculated_height : Natural := step_size;
      calculated_y : Natural := 20;
   begin
      calculated_height := step_size*((Natural(audio_volume)/10)+1);
      calculated_y := y_base - calculated_height;

      Screen.Draw_Filled_Rectangle(X                => 15,
                                   Y                => y_base - max_height,
                                   Width_In_Pixels  => 20,
                                   Height_In_Pixels => max_height,
                                   Color            => current_bg);

      Screen.Draw_Filled_Rectangle(X                => 15,
                                   Y                => calculated_y,
                                   Width_In_Pixels  => 20,
                                   Height_In_Pixels => calculated_height,
                                   Color            => current_text);
   end Draw_Current_Volume;

   procedure get_current_colors(effect_bg : out Colors; effect_text_color : out Colors)
   is
   begin
      -- Based on current effect, select different colors
      effect_bg := Red;
      effect_text_color := Black;

      if (current_effect = 0) then
         effect_bg := Red;
         effect_text_color := Black;
      elsif(current_effect = 1) then
         effect_bg := Black;
         effect_text_color := Yellow;
      elsif(current_effect = 2) then
         effect_bg := Blue;
         effect_text_color := White;
      elsif(current_effect = 3) then
         effect_bg := Magenta;
         effect_text_color := White;
      elsif(current_effect = 4) then
         effect_bg := Red;
         effect_text_color := Blue;
      else
         -- Raise an exception
         raise Program_Error with "Not defined colors for this value";
      end if;

   end get_current_colors;

   procedure Write_Current_Effect_Name is
   begin
      if (current_effect = 0) then
         --Put_String_Screen("Nice");
         Put_String_Screen(Almost_Raw.Effect_Name);
      elsif(current_effect = 1) then
         --Put_String_Screen("Very well");
         Put_String_Screen(Only_Voice.Effect_Name);
      elsif(current_effect = 2) then
         --Put_String_Screen("Not that good");
         Put_String_Screen(Echo.Effect_Name);
      elsif(current_effect = 3) then
         --Put_String_Screen("Not that good");
         Put_String_Screen(Pitch.Effect_Name);
      elsif(current_effect = 4) then
         --Put_String_Screen("Not that good");
         Put_String_Screen(Robot.Effect_Name);
      else
         -- Raise an exception
         raise Program_Error with "Not defined name for this value";
      end if;
   end Write_Current_Effect_Name;

   procedure Write_Ready is
   begin
      Screen.Print_String(X                => 200,
                          Y                => 200,
                          Text             => "RDY",
                          Foreground_Color => current_text,
                          Background_Color => current_bg);
   end;

   procedure Process_Effect_Transition(Direction : Gesture)
   is
   begin
      -- Disable taking measurements
      Disable (Sampling_Timer);
      HAL_Time.Delay_Milliseconds(10);

      -- Reset all audio variables
      Audio_Data_0 := (others => 0);
      Audio_Data_1 := (others => 0);

      -- Stop audio reproduction
      --STM32.Board.Audio_DAC.Stop;

      if(Direction = Left) then
         current_effect := current_effect + 1;
         get_current_colors(current_bg, current_text);
         Fill_Screen_Right;
      else  -- Else, direction = right
         current_effect := current_effect - 1;
         get_current_colors(current_bg, current_text);
         Fill_Screen_Left;
      end if;

      -- Reset variables of all the effects
      First_Effect.Reset_Variables;
      Second_Effect.Reset_Variables;
      Third_Effect.Reset_Variables;

      get_current_colors(current_bg, current_text);
      Write_Current_Effect_Name;
      Draw_Current_Volume;
      Draw_G_State;
      Write_Ready;

      -- Restore audio reproduction
      --STM32.Board.Audio_DAC.Play;
      -- Enable taking measurements
      Enable (Sampling_Timer);
   end Process_Effect_Transition;

   procedure Draw_G_State
   is
   begin
      Screen.Draw_Filled_Rectangle(X                => 220,
                                   Y                => 10,
                                   Width_In_Pixels  => 100,
                                   Height_In_Pixels => 40,
                                   Color            => current_bg);
      if (curren_status_gesture) then
         Screen.Print_String(X                => 220,
                             Y                => 10,
                             Text             => "G-ON",
                             Foreground_Color => current_text,
                             Background_Color => current_bg);
      else
         Screen.Print_String(X                => 220,
                             Y                => 10,
                             Text             => "G-OFF",
                             Foreground_Color => current_text,
                             Background_Color => current_bg);
      end if;

   end Draw_G_State;

   task body Gesture_Controller is
   begin
      -- Wait until all modules are started before starting with this task
      --Turn_On(Orange_LED);
      Suspend_Until_True(Finished_Init);

      -- Discard interrupts that ocurred before starting this task
      -- Update: NO interrupts before, module enabled here

      -- Configure gesture sensor:
      Gesture_Object.Init;
      -- Start with sensor Activated
      Gesture_Object.Enable_Gesture_Sensor;

      -- Output a message saying "System is ready"
      Put_String_Screen(Text => "Ready to Rock!");
      HAL_Time.Delay_Seconds(1);
      Erase_String_Screen;

      HAL_Time.Delay_Seconds(1);
      get_current_colors(effect_bg         => current_bg,
                         effect_text_color => current_text);
      Screen.Fill(Color => current_bg);

      -- Draw the name of the current effect (default name)
      Put_String_Screen(Current_Name);
      Draw_Current_Volume;
      Write_Ready;
      Draw_G_State;
      STM32.Board.Audio_DAC.Play;
      STM32.Board.Audio_DAC.Set_Volume (audio_volume);

      Enable (Sampling_Timer);
      --Gesture_Object.Disable_Gesture_Sensor;
      -- Enable user button interrupts
      User_Button.Initialize;

      loop
         Suspend_Until_True(Event_New_Gesture);

         -- Take action if new button interrupt as well
         if (User_Button.Has_Been_Pressed = True) then
            -- Stop sampling for a moment
            Disable (Sampling_Timer);
            HAL_Time.Delay_Milliseconds(10);

            -- Reset all audio variables
            Audio_Data_0 := (others => 0);
            Audio_Data_1 := (others => 0);

            -- (de)Activate gesture sensor, for the purpose of reducing
            -- noise in the adc (and save battery)
            if(curren_status_gesture) then
               Gesture_Object.Disable_Gesture_Sensor;
            else
               Gesture_Object.Enable_Gesture_Sensor;
            end if;
            -- Switch state of the sensor
            curren_status_gesture := not curren_status_gesture;
            Draw_G_State;
            Toggle(Blue_LED);
            Enable(Sampling_Timer);

         else
            -- Read command
            read_gesture := Gesture_Object.readGesture;

            -- Filter noisy gesture detections
            -- only update last_command on up, down, left, right
            if( Clock > Last_Command  + Delay_Between_Commands) then

               -- This section of code "translates" the actual input,
               -- based on the orientation of the gesture sensor in
               -- your setup
               if(read_gesture = Down) then read_gesture := Right;
               elsif(read_gesture = Up) then read_gesture := Left;
               elsif(read_gesture = Left) then read_gesture := Down;
               elsif(read_gesture = Right) then read_gesture := Up;
               end if;

               -- Take actions based on the inputs
               -- 4 available actions:
               -- Right: Increase effect
               -- Left: Decrease effect
               -- UP: Increase volume
               -- Down: Decrease volume

               if (read_gesture = Up) then
                  Turn_On(Orange_LED);
                  -- Increase DAC volume
                  if (audio_volume /= 100) then
                     audio_volume := audio_volume + 10;
                     STM32.Board.Audio_DAC.Set_Volume (audio_volume);
                     Draw_Current_Volume;
                  end if;
                  Last_Command := Clock;
                  Turn_Off(Orange_LED);
               elsif(read_gesture = Down) then
                  Turn_On(Blue_LED);
                  -- Decrease DAC volume
                  if (audio_volume /= 0) then
                     audio_volume := audio_volume - 10;
                     STM32.Board.Audio_DAC.Set_Volume (audio_volume);
                     Draw_Current_Volume;
                  end if;
                  Last_Command := Clock;
                  Turn_Off(Blue_LED);
               elsif( read_gesture = Left) then
                  Turn_On(Green_LED);
                  Process_Effect_Transition(Left);
                  Last_Command := Clock;
                  Turn_Off(Green_LED);
               elsif(read_gesture = Right) then
                  Turn_On(Red_LED);
                  Process_Effect_Transition(Right);
                  Last_Command := Clock;
                  Turn_Off(Red_LED);
               else
                  -- Specific action for "none" detected
                  -- None at the moment
                  null;
               end if;
            end if;
         end if;

      end loop;

   end Gesture_Controller;

end Gesture_Manager;
