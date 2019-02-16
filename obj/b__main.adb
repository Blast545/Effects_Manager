pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;

package body ada_main is

   E093 : Short_Integer; pragma Import (Ada, E093, "system__soft_links_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "system__exception_table_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "ada__tags_E");
   E079 : Short_Integer; pragma Import (Ada, E079, "system__bb__timing_events_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "ada__streams_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "system__finalization_root_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "ada__finalization_E");
   E161 : Short_Integer; pragma Import (Ada, E161, "system__storage_pools_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "system__finalization_masters_E");
   E137 : Short_Integer; pragma Import (Ada, E137, "ada__real_time_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "system__pool_global_E");
   E118 : Short_Integer; pragma Import (Ada, E118, "system__tasking__protected_objects_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "system__tasking__protected_objects__multiprocessors_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "system__tasking__restricted__stages_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "bmp_fonts_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "cortex_m__cache_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "hal__audio_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "hal__audio_effect_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "almost_raw_E");
   E270 : Short_Integer; pragma Import (Ada, E270, "echo_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "hal__block_drivers_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "hal__gpio_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "hal__i2c_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "hal__real_time_clock_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "hal__sdmmc_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "hal__spi_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "hal__time_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "cs43l22_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "hal__uart_E");
   E272 : Short_Integer; pragma Import (Ada, E272, "ili9341_extended_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "lis3dsh_E");
   E266 : Short_Integer; pragma Import (Ada, E266, "lis3dsh__spi_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "only_voice_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "pitch_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "ravenscar_time_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "robot_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "sdmmc_init_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "stm32__adc_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "stm32__dac_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "stm32__dma__interrupts_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "stm32__exti_E");
   E298 : Short_Integer; pragma Import (Ada, E298, "apds9960_interrupts_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "stm32__power_control_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "stm32__rtc_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "stm32__spi_E");
   E256 : Short_Integer; pragma Import (Ada, E256, "stm32__spi__dma_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "stm32__i2c_E");
   E260 : Short_Integer; pragma Import (Ada, E260, "stm32__usarts_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "stm32__sdmmc_interrupt_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "stm32__i2s_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "stm32__i2c__dma_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "stm32__gpio_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "stm32__sdmmc_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "stm32__syscfg_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "stm32__device_E");
   E294 : Short_Integer; pragma Import (Ada, E294, "audio_stream_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "stm32__setup_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "stm32__board_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "apds9960_gesture_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "custom_board_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "adc_interrupt_handling_E");
   E302 : Short_Integer; pragma Import (Ada, E302, "last_chance_handler_E");
   E304 : Short_Integer; pragma Import (Ada, E304, "stm32f4_timer_interrupts_E");
   E300 : Short_Integer; pragma Import (Ada, E300, "user_button_E");
   E296 : Short_Integer; pragma Import (Ada, E296, "gesture_manager_E");

   Sec_Default_Sized_Stacks : array (1 .. 2) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := 0;
      Time_Slice_Value := 0;
      WC_Encoding := 'b';
      Locking_Policy := 'C';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := 'F';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, True, True, False, False, False, False, True, 
           False, False, False, False, False, False, False, True, 
           True, False, False, False, False, False, True, False, 
           False, False, False, False, False, False, False, False, 
           True, True, False, False, True, True, False, False, 
           False, True, False, False, False, False, True, False, 
           True, True, False, False, False, False, True, True, 
           True, True, True, False, True, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, True, False, False, 
           False, False, False, False, False, False, True, True, 
           False, True, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (False, False, False, False, True, True, False, False, 
           False, False, False, True, True, True, True, False, 
           False, False, False, False, True, True, False, True, 
           True, False, True, True, False, True, False, False, 
           False, False, False, True, False, False, True, False, 
           False, False, True, True, False, False, False, True, 
           False, False, False, True, False, False, False, False, 
           False, False, False, True, False, True, True, True, 
           False, False, True, False, True, True, True, False, 
           True, True, False, False, True, True, True, False, 
           False, True, False, False, False, True, False, False, 
           True, False, True, False),
         Count => (0, 0, 0, 1, 0, 0, 1, 0, 6, 0),
         Unknown => (False, False, False, False, False, False, False, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 1;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 2;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E091 := E091 + 1;
      Ada.Tags'Elab_Body;
      E057 := E057 + 1;
      System.Bb.Timing_Events'Elab_Spec;
      E093 := E093 + 1;
      E079 := E079 + 1;
      Ada.Streams'Elab_Spec;
      E151 := E151 + 1;
      System.Finalization_Root'Elab_Spec;
      E159 := E159 + 1;
      Ada.Finalization'Elab_Spec;
      E157 := E157 + 1;
      System.Storage_Pools'Elab_Spec;
      E161 := E161 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E154 := E154 + 1;
      Ada.Real_Time'Elab_Body;
      E137 := E137 + 1;
      System.Pool_Global'Elab_Spec;
      E163 := E163 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E118 := E118 + 1;
      System.Tasking.Protected_Objects.Multiprocessors'Elab_Body;
      E122 := E122 + 1;
      System.Tasking.Restricted.Stages'Elab_Body;
      E127 := E127 + 1;
      E275 := E275 + 1;
      E244 := E244 + 1;
      HAL.AUDIO'ELAB_SPEC;
      E177 := E177 + 1;
      HAL.AUDIO_EFFECT'ELAB_SPEC;
      E178 := E178 + 1;
      Almost_Raw'Elab_Spec;
      Almost_Raw'Elab_Body;
      E176 := E176 + 1;
      Echo'Elab_Spec;
      Echo'Elab_Body;
      E270 := E270 + 1;
      HAL.BLOCK_DRIVERS'ELAB_SPEC;
      E253 := E253 + 1;
      HAL.GPIO'ELAB_SPEC;
      E209 := E209 + 1;
      HAL.I2C'ELAB_SPEC;
      E217 := E217 + 1;
      HAL.REAL_TIME_CLOCK'ELAB_SPEC;
      E234 := E234 + 1;
      HAL.SDMMC'ELAB_SPEC;
      E248 := E248 + 1;
      HAL.SPI'ELAB_SPEC;
      E149 := E149 + 1;
      HAL.TIME'ELAB_SPEC;
      E168 := E168 + 1;
      CS43L22'ELAB_SPEC;
      CS43L22'ELAB_BODY;
      E264 := E264 + 1;
      HAL.UART'ELAB_SPEC;
      E262 := E262 + 1;
      Ili9341_Extended'Elab_Spec;
      Ili9341_Extended'Elab_Body;
      E272 := E272 + 1;
      LIS3DSH'ELAB_SPEC;
      LIS3DSH'ELAB_BODY;
      E184 := E184 + 1;
      LIS3DSH.SPI'ELAB_SPEC;
      LIS3DSH.SPI'ELAB_BODY;
      E266 := E266 + 1;
      Only_Voice'Elab_Spec;
      Only_Voice'Elab_Body;
      E277 := E277 + 1;
      Pitch'Elab_Spec;
      Pitch'Elab_Body;
      E279 := E279 + 1;
      Ravenscar_Time'Elab_Spec;
      Ravenscar_Time'Elab_Body;
      E167 := E167 + 1;
      Robot'Elab_Spec;
      Robot'Elab_Body;
      E281 := E281 + 1;
      E246 := E246 + 1;
      STM32.ADC'ELAB_SPEC;
      E133 := E133 + 1;
      E195 := E195 + 1;
      E229 := E229 + 1;
      E170 := E170 + 1;
      Apds9960_Interrupts'Elab_Spec;
      E298 := E298 + 1;
      E236 := E236 + 1;
      STM32.RTC'ELAB_SPEC;
      STM32.RTC'ELAB_BODY;
      E233 := E233 + 1;
      STM32.SPI'ELAB_SPEC;
      STM32.SPI'ELAB_BODY;
      E173 := E173 + 1;
      STM32.SPI.DMA'ELAB_SPEC;
      STM32.SPI.DMA'ELAB_BODY;
      E256 := E256 + 1;
      STM32.I2C'ELAB_SPEC;
      STM32.USARTS'ELAB_SPEC;
      STM32.I2S'ELAB_SPEC;
      STM32.I2C.DMA'ELAB_SPEC;
      STM32.GPIO'ELAB_SPEC;
      STM32.SDMMC'ELAB_SPEC;
      E252 := E252 + 1;
      STM32.GPIO'ELAB_BODY;
      E201 := E201 + 1;
      STM32.DEVICE'ELAB_SPEC;
      E188 := E188 + 1;
      STM32.SDMMC'ELAB_BODY;
      E241 := E241 + 1;
      STM32.I2S'ELAB_BODY;
      E231 := E231 + 1;
      STM32.I2C.DMA'ELAB_BODY;
      E219 := E219 + 1;
      STM32.I2C'ELAB_BODY;
      E213 := E213 + 1;
      E206 := E206 + 1;
      STM32.USARTS'ELAB_BODY;
      E260 := E260 + 1;
      Audio_Stream'Elab_Spec;
      E294 := E294 + 1;
      E186 := E186 + 1;
      STM32.BOARD'ELAB_SPEC;
      E182 := E182 + 1;
      apds9960_gesture'elab_spec;
      apds9960_gesture'elab_body;
      E180 := E180 + 1;
      Custom_Board'Elab_Spec;
      E148 := E148 + 1;
      Adc_Interrupt_Handling'Elab_Spec;
      E129 := E129 + 1;
      E302 := E302 + 1;
      Stm32f4_Timer_Interrupts'Elab_Spec;
      E304 := E304 + 1;
      User_Button'Elab_Body;
      E300 := E300 + 1;
      Gesture_Manager'Elab_Spec;
      Gesture_Manager'Elab_Body;
      E296 := E296 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   procedure main is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
   end;

--  BEGIN Object file/option list
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\bmp_fonts.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\hal-audio_effect.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\Almost_Raw.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\Echo.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\ili9341_extended.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\Only_voice.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\Pitch.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\Robot.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\apds9960_interrupts.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\audio_stream.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\apds9960_gesture.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\custom_board.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\adc_interrupt_handling.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\last_chance_handler.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\stm32f4_timer_interrupts.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\user_button.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\Gesture_Manager.o
   --   C:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\main.o
   --   -LC:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\
   --   -LC:\Users\DELL\Documents\Ada_Projects\Effects_Manager\obj\
   --   -LC:\Users\DELL\Documents\Ada_Projects\Effects_Manager\Ada_Drivers_Library\obj_lib_Debug\
   --   -LC:\gnat\2018-arm-elf\arm-eabi\lib\gnat\ravenscar-full-stm32f4\adalib\
   --   -static
   --   -lgnarl
   --   -lgnat
--  END Object file/option list   

end ada_main;
