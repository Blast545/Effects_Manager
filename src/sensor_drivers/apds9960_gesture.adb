------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2015, AdaCore                           --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of STMicroelectronics nor the names of its       --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
------------------------------------------------------------------------------

--  This file provides a driver for the for the APDS9960 sensor, used in gesture mode
--  Refer to APDS-9960 Digital Proximity, Ambient Light, RGB and Gesture Sensor, datasheet 
--  For more information

--with Interfaces; use Interfaces;
--with HAL;        use HAL;
--with HAL.GPIO;   use HAL.GPIO;
with Ada.Unchecked_Conversion;
with STM32.Board; use STM32.Board;

package body apds9960_gesture  is

   function As_Bit_Position is new Ada.Unchecked_Conversion
     (Source => sensor_mode, Target => T_Bit_Pos_8);
   function As_UInt8 is new Ada.Unchecked_Conversion
     (Source => enable_status, Target => UInt8);
   
   -- Init procedure. Be sure I2C is ready to be used before calling
   -- this package functions
   procedure Init (This        : in out APDS9960_Device) is       
      read_id : UInt8;
   begin

      read_id := This.I2C_Read(Reg    => APDS9960_ID,
                               Status => This.Last_Status_I2C);

      -- Check if it is a valid gesture senssor
      if ( not (read_id = APDS9960_ID_1 or read_id = APDS9960_ID_2) ) then
         All_LEDs_On;
         raise Program_Error with "Gesture addr not recognized";
      end if;     
      
      -- Set ENABLE register to 0 (disable all features)
      This.setMode(used_mode   => Use_All,
                   used_enable => OFF);     
      
      -- Set default variables for ambient light and proximity sensors
      This.I2C_Write(Reg    => APDS9960_ATIME,
                     Value  => DEFAULT_ATIME,
                     Status => This.Last_Status_I2C);
      
      This.I2C_Write(Reg    => APDS9960_WTIME,
                     Value  => DEFAULT_WTIME,
                     Status => This.Last_Status_I2C);

      This.I2C_Write(Reg    => APDS9960_PPULSE,
                     Value  => DEFAULT_PROX_PPULSE,
                     Status => This.Last_Status_I2C);
      This.I2C_Write(Reg    => APDS9960_POFFSET_UR,
                     Value  => DEFAULT_POFFSET_UR,
                     Status => This.Last_Status_I2C);
      This.I2C_Write(Reg    => APDS9960_POFFSET_DL,
                     Value  => DEFAULT_POFFSET_DL,
                     Status => This.Last_Status_I2C);
      
      This.I2C_Write(Reg    => APDS9960_CONFIG1,
                     Value  => DEFAULT_CONFIG1,
                     Status => This.Last_Status_I2C);
      
      This.setLEDDrive(Value => DEFAULT_LDRIVE);
      This.setProximityGain(Value => DEFAULT_PGAIN);      
--        This.setProxIntLowThresh(Value => DEFAULT_PILT);
--        This.setProxIntHighThresh(Value => DEFAULT_PIHT);
      
      This.I2C_Write(Reg    => APDS9960_PILT,
                     Value  => DEFAULT_PILT,
                     Status => This.Last_Status_I2C);
      This.I2C_Write(Reg    => APDS9960_PIHT,
                     Value  => DEFAULT_PIHT,
                     Status => This.Last_Status_I2C);
      
      This.I2C_Write(Reg    => APDS9960_PERS,
                     Value  => DEFAULT_PERS,
                     Status => This.Last_Status_I2C);

      This.I2C_Write(Reg    => APDS9960_CONFIG2,
                     Value  => DEFAULT_CONFIG2,
                     Status => This.Last_Status_I2C);
      
      This.I2C_Write(Reg    => APDS9960_CONFIG3,
                     Value  => DEFAULT_CONFIG3,
                     Status => This.Last_Status_I2C);

      -- Set default values for gesture sense registers   
      This.I2C_Write(Reg    => APDS9960_GPENTH,
                     Value  => DEFAULT_GPENTH,
                     Status => This.Last_Status_I2C);
      This.I2C_Write(Reg    => APDS9960_GEXTH,
                     Value  => DEFAULT_GEXTH,
                     Status => This.Last_Status_I2C);
      This.I2C_Write(Reg    => APDS9960_GCONF1,
                     Value  => DEFAULT_GCONF1,
                     Status => This.Last_Status_I2C);
      This.setGestureGain(Gain => DEFAULT_GGAIN);      
      This.setGestureLedDrive(Drive => DEFAULT_GLDRIVE);
      This.setGestureWaitTime(Time => DEFAULT_GWTIME);
      
      This.I2C_Write(Reg    => APDS9960_GOFFSET_U,
                     Value  => DEFAULT_GOFFSET,
                     Status => This.Last_Status_I2C);

      This.I2C_Write(Reg    => APDS9960_GOFFSET_D,
                     Value  => DEFAULT_GOFFSET,
                     Status => This.Last_Status_I2C); 

      This.I2C_Write(Reg    => APDS9960_GOFFSET_L,
                     Value  => DEFAULT_GOFFSET,
                     Status => This.Last_Status_I2C); 
      
      This.I2C_Write(Reg    => APDS9960_GOFFSET_R,
                     Value  => DEFAULT_GOFFSET,
                     Status => This.Last_Status_I2C); 
      
      This.I2C_Write(Reg    => APDS9960_GPULSE,
                     Value  => DEFAULT_GPULSE,
                     Status => This.Last_Status_I2C);
      
      This.I2C_Write(Reg    => APDS9960_GCONF3,
                     Value  => DEFAULT_GCONF3,
                     Status => This.Last_Status_I2C);  

      This.setGestureIntEnable(Enable => DEFAULT_GIEN);
      
   end Init;
   
   procedure setMode(This        : in out APDS9960_Device;
                     used_mode : sensor_mode; used_enable : enable_status)
   is 
      reg_val : UInt8 := 0;
      shifted_value : UInt8 := 0;  
   begin
      
      -- Get current value from enable register
      -- reg_val := getMode();
      reg_val := This.I2C_Read(Reg    => APDS9960_ENABLE,
                               Status => This.Last_Status_I2C);
      
      -- Check if mode is "all" or other mode
      if ( used_mode = Use_All ) then
         if (used_enable = ON) then
            reg_val := 16#7F#;
         else
            reg_val := 16#00#;
         end if;
      else
         shifted_value := Shift_Left(Value  => 1,
                                     Amount => As_Bit_Position(used_mode));
         if (used_enable = ON) then            
            reg_val := reg_val or shifted_value;
            --reg_val := reg_val or (1 << UInt8(used_mode) );
         else
            reg_val := reg_val and (not shifted_value);
            --reg_val := reg_val and (not (1 << UInt8(used_mode) ) );
         end if;
      end if;
        
      This.I2C_Write(Reg    => APDS9960_ENABLE,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
      
   end setMode; 
         
   procedure setGestureGain(This        : in out APDS9960_Device;
                            Gain : UInt8) 
   is
      reg_val : UInt8 := 0;
      aux_gain: UInt8 := Gain and 2#0000_0011#;
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_GCONF2,
                               Status => This.Last_Status_I2C);
      --aux_gain := aux_gain << 5;
      aux_gain := Shift_Left(Value  => aux_gain,
                             Amount => 5);
      
      reg_val := reg_val and 2#1001_1111#;
      reg_val := reg_val or aux_gain;
      
      This.I2C_Write(Reg    => APDS9960_GCONF2,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
   end setGestureGain;
   
   procedure setGestureLedDrive(This        : in out APDS9960_Device;
                                Drive : UInt8) 
   is
      reg_val : UInt8 := 0;
      aux_drive: UInt8 := Drive and 2#0000_0011#;      
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_GCONF2,
                               Status => This.Last_Status_I2C);
      
      --aux_drive := aux_drive <<3;
      aux_drive := Shift_Left(Value  => aux_drive,
                              Amount => 5);
      reg_val := reg_val and 2#1110_0111#;
      reg_val := reg_val or aux_drive;
      
      This.I2C_Write(Reg    => APDS9960_GCONF2,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
   end setGestureLedDrive;
   
   procedure setGestureWaitTime(This        : in out APDS9960_Device;                                
                                Time : UInt8) 
   is
      reg_val : UInt8 := 0;
      --aux_time: UInt8 := Time and 2#0000_0111#;            
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_GCONF2,
                               Status => This.Last_Status_I2C);
      
      reg_val := reg_val and 2#1111_1000#;
      reg_val := reg_val or (Time and 2#0000_0111#);
      
      This.I2C_Write(Reg    => APDS9960_GCONF2,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
      
   end setGestureWaitTime;
   
   procedure setGestureIntEnable(This : in out APDS9960_Device;                                
                                 Enable : enable_status) is
      reg_val : UInt8 := 0;
      aux_enable: UInt8 := As_UInt8(Enable);
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_GCONF4,
                               Status => This.Last_Status_I2C);
      --aux_enable := aux_enable << 1;
      aux_enable := Shift_Left(Value  => aux_enable,
                               Amount => 1);
      reg_val := reg_val and 2#1111_1101#;
      reg_val := reg_val or aux_enable;
      
      This.I2C_Write(Reg    => APDS9960_GCONF4,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
      end setGestureIntEnable;
      
   procedure setLedBoost(This : in out APDS9960_Device;                                
                         Boost : UInt8)
   is
      reg_val : UInt8 := 0;
      aux_boost: UInt8 := Boost and 2#0000_0011#;
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_CONFIG2,
                               Status => This.Last_Status_I2C);
      --aux_boost := aux_boost << 4;
      aux_boost := Shift_Left(Value  => aux_boost,
                              Amount => 4);
      reg_val := reg_val and 2#1100_1111#;
      reg_val := reg_val or aux_boost;
      
      This.I2C_Write(Reg    => APDS9960_CONFIG2,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
   end setLedBoost;
   
   procedure setGestureMode(This        : in out APDS9960_Device;
                            Enable : enable_status)
   is
      reg_val : UInt8 := 0;
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_GCONF4,
                               Status => This.Last_Status_I2C);
      reg_val := reg_val and 2#1111_1110#;
      reg_val := reg_val or As_UInt8(Enable);
      
      This.I2C_Write(Reg    => APDS9960_GCONF4,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
   end setGestureMode;
   
   procedure setLEDDrive(This        : in out APDS9960_Device;                                
                         Value : UInt8)
   is 
      reg_val : UInt8 := 0;
      aux_value: UInt8 := Value and 2#0000_0011#;
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_CONTROL,
                               Status => This.Last_Status_I2C);

      aux_value := Shift_Left(Value  => aux_value,
                              Amount => 6);
      reg_val := reg_val and 2#0011_1111#;
      reg_val := reg_val or aux_value;
      
      This.I2C_Write(Reg    => APDS9960_CONTROL,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
   end setLEDDrive;

   procedure setProximityGain(This        : in out APDS9960_Device;                                
                              Value : UInt8)
   is
      reg_val : UInt8 := 0;
      aux_value: UInt8 := Value and 2#0000_0011#;
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_CONTROL,
                               Status => This.Last_Status_I2C);
      aux_value := Shift_Left(Value  => aux_value,
                              Amount => 2);
      reg_val := reg_val and 2#1111_0011#;
      reg_val := reg_val or aux_value;
      
      This.I2C_Write(Reg    => APDS9960_CONTROL,
                     Value  => reg_val,
                     Status => This.Last_Status_I2C);
   end setProximityGain;
      
   procedure Enable_Gesture_Sensor(This        : in out APDS9960_Device) 
   is 
   begin
      --Reset_Gesture_Parameters(This);
      This.I2C_Write(Reg    => APDS9960_WTIME,
                     Value  => 16#FF#,
                     Status => This.Last_Status_I2C);
      This.I2C_Write(Reg    => APDS9960_PPULSE,
                     Value  => DEFAULT_GESTURE_PPULSE,
                     Status => This.Last_Status_I2C);
      --This.setLedBoost(Boost => LED_BOOST_300);
      This.setLedBoost(Boost => DEFAULT_BOOST);
      -- Enable interrupts as default mechanism
      This.setGestureIntEnable(Enable => ON);
      This.setGestureMode(Enable => ON);
      -- Enable power function
      This.setMode(used_mode   => Power,
                   used_enable => ON);
      This.setMode(used_mode   => Wait,
                   used_enable => ON);
      This.setMode(used_mode   => Proximity,
                   used_enable => ON);
      This.setMode(used_mode   => Gesture_Mode,
                   used_enable => ON);
   end Enable_Gesture_Sensor;
   
   procedure Disable_Gesture_Sensor(This       : in out APDS9960_Device) 
   is
   begin 
      --Reset_Gesture_Parameters(This);
      This.setMode(used_mode   => Power,
                   used_enable => OFF);
      This.setGestureIntEnable(Enable => OFF);
      This.setGestureMode(Enable => OFF);
      This.setMode(used_mode   => Gesture_Mode,
                   used_enable => OFF);
      
   end Disable_Gesture_Sensor;
   
   function isGestureAvailable(This : in out APDS9960_Device) return Boolean 
   is
      reg_val : Uint8 := 0;
   begin
      reg_val := This.I2C_Read(Reg    => APDS9960_GSTATUS,
                               Status => This.Last_Status_I2C);
      reg_val := reg_val and 16#01#;
      if( reg_val = 16#01# ) then
         return True;
      else 
         return False;
      end if;
      
   end isGestureAvailable;
      
   function readGesture(This : in out APDS9960_Device) return Gesture 
   is
      --type gesture_fifo_array is array (Natural range 1 .. 128) of UInt8;
      --fifo_data : gesture_fifo_array;
      --fifo_data : UInt8_Array (1 .. 128) := (others => 0);
      fifo_dataset : UInt8_Array (1 .. 4) := (others => 0);
      fifo_level : Uint8;
      --bytes_read : Uint8;
      g_status : Uint8;
      up_down_diff : Integer := 0;
      left_right_diff : Integer := 0;      
      UCount : UInt8 := 0;
      DCount : UInt8 := 0;
      RCount : UInt8 := 0;
      LCount : UInt8 := 0;
      
   begin
      if ( isGestureAvailable(This) = False) then 
         return None;
      end if; 
      
      loop 
         up_down_diff := 0;
         left_right_diff := 0;
         
         This.Time.Delay_Milliseconds(FIFO_PAUSE_TIME);         
         g_status := This.I2C_Read(Reg    => APDS9960_GSTATUS,
                                   Status => This.Last_Status_I2C);
         if( (g_status and APDS9960_GVALID) = APDS9960_GVALID) then
            fifo_level := This.I2C_Read(Reg    => APDS9960_GFLVL,
                                        Status => This.Last_Status_I2C);
            if(fifo_level > 0) then
               fifo_dataset := (others => 0);
               This.I2C_Read_Buffer(Reg    => APDS9960_GFIFO_U,
                                    Value  => fifo_dataset,
                                    Status => This.Last_Status_I2C);
               if ( abs( Integer(fifo_dataset(1)) - Integer(fifo_dataset(2)) ) > 13 ) then
                  up_down_diff := up_down_diff + Integer(fifo_dataset(1)) - Integer(fifo_dataset(2));                  
               end if;               
               
               if ( abs( Integer(fifo_dataset(3)) - Integer(fifo_dataset(4)) ) > 13 ) then
                  left_right_diff := left_right_diff + Integer(fifo_dataset(3)) - Integer(fifo_dataset(4));                  
               end if;
               
               if (up_down_diff /= 0) then
                  if( up_down_diff < 0) then
                     if( DCount > 0) then 
                        if (fifo_level>1) then
                          This.empty_fifo(fifo_level-1);
                        end if;
                        return Up;
                     else
                        UCount := UCount + 1;
                     end if;
                  elsif ( up_down_diff > 0) then 
                     if (UCount > 0) then
                        if (fifo_level>1) then
                          This.empty_fifo(fifo_level-1);
                        end if;
                        return Down;
                     else
                        DCount := DCount+1;               
                     end if;
                  end if;                     
               end if;
                              
               if(left_right_diff /= 0) then
                  if(left_right_diff < 0) then                     
                     if(RCount > 0) then
                        if (fifo_level>1) then
                          This.empty_fifo(fifo_level-1);
                        end if;
                        return Left;
                     else 
                        LCount := LCount+1;
                     end if;
                     
                  elsif(left_right_diff>0) then                     
                     if(LCount > 0) then
                        if (fifo_level>1) then
                          This.empty_fifo(fifo_level-1);
                        end if;
                        return Right;
                     else 
                        RCount := RCount +1;
                     end if;
                  end if;                  
               end if;
               
            else
               return None;
            end if;            
         else
            This.Time.Delay_Milliseconds(FIFO_PAUSE_TIME);  
            --motion := None;
            --Reset_Gesture_Parameters(This);
            return None;
         end if;
      end loop;
      
   end readGesture;
   
   procedure empty_fifo(This        : in out APDS9960_Device;
                        fifo_level : Uint8)
   is
      fifo_dataset : UInt8_Array (1 .. Integer(fifo_level*4)) := (others => 0);
   begin      
      -- Check if there is data available first
      while ( isGestureAvailable(This) = True) loop  
      
         -- Read the remaining values of the fifo
         This.I2C_Read_Buffer(Reg    => APDS9960_GFIFO_U,
                              Value  => fifo_dataset,
                              Status => This.Last_Status_I2C);      
         This.Time.Delay_Milliseconds(FIFO_PAUSE_TIME);        

      end loop;      

   end empty_fifo;
   
   procedure I2C_Write(This  : in out APDS9960_Device;
                       Reg   : UInt8;
                       Value : UInt8;
                       Status : out I2C_Status)  is
   begin
      This.Port.Mem_Write
        (Addr          => Apds9960_I2C_Addr,
         Mem_Addr      => UInt16 (Reg),
         Mem_Addr_Size => Memory_Size_8b,
         Data          => (1 => Value),
         Status        => Status);
      if Status /= Ok then
         raise Program_Error with "I2C write error:" & Status'Img;
      end if;
   end I2C_Write;
   
   function I2C_Read (This : in out APDS9960_Device;
                      Reg  : UInt8;
                      Status : out I2C_Status)
                      return UInt8
   is
      Data : I2C_Data(1 .. 1);
   begin
      This.Port.Mem_Read
        (Addr          => Apds9960_I2C_Addr,
         Mem_Addr      => UInt16 (Reg),
         Mem_Addr_Size => Memory_Size_8b,
         Data          => Data,
         Status        => Status);
      if Status /= Ok then
         raise Program_Error with "I2C read buff error:" & Status'Img;
      end if;
      return Data (1);
   end I2C_Read;
         
   procedure I2C_Read_Buffer(This  : in out APDS9960_Device;
                             Reg   : UInt8;
                             Value : out I2C_Data;
                             Status : out I2C_Status)   
   is
   begin
      This.Port.Mem_Read
        (Addr          => Apds9960_I2C_Addr,
         Mem_Addr      => UInt16 (Reg),
         Mem_Addr_Size => Memory_Size_8b,
         Data          => Value,
         Status        => Status);
      if Status /= Ok then
         raise Program_Error with "I2C read buff error:" & Status'Img;
      end if;
   end I2C_Read_Buffer;   
       
end apds9960_gesture;


