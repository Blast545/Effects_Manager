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
with HAL;        use HAL;
--with HAL.GPIO;   use HAL.GPIO;
with HAL.I2C;    use HAL.I2C;
with HAL.Time;   use HAL.Time;

package apds9960_gesture is

   type APDS9960_Device (Port : not null Any_I2C_Port;
                        Time : not null HAL.Time.Any_Delays) is 
     tagged limited private;
   
   --Apds9960_I2C_Addr : constant := 16#39#;
   Apds9960_I2C_Addr : constant := 16#72#;
   APDS9960_ID_1 : constant := 16#AB#;
   APDS9960_ID_2 : constant := 16#9C#;
   
   -- Far and Near are not used in this project
   type Gesture is (None, Up, Down, Left, Right, Far, Near);
   for Gesture use 
     (None => 16#0#,
      Up => 16#1#,
      Down => 16#2#,
      Left => 16#3#,
      Right => 16#4#,
      Far => 16#5#, 
      Near => 16#6#);
   for Gesture'Size use 8;
   
   type sensor_mode is (Power, Ambient_Light, Proximity, Wait, 
                        Ambient_Light_Int, Proximity_Int, Gesture_Mode, Use_All);
   for sensor_mode use
     (Power             => 16#00#,
      Ambient_Light     => 16#01#,
      Proximity         => 16#02#,
      Wait              => 16#03#,
      Ambient_Light_Int => 16#04#,
      Proximity_Int     => 16#05#,
      Gesture_Mode      => 16#06#,
      Use_All           => 16#07#);
   for sensor_mode'Size use 3;
   
   -- Definition required to use the shift_left interfaces function
   subtype T_Bit_Pos_8 is Natural range 0 .. 7;
   
   type enable_status is (OFF, ON);
   for enable_status use (OFF => 16#00#, ON => 16#01#);
   for enable_status'Size use 8;
 
   procedure setMode(This        : in out APDS9960_Device;
                     used_mode : sensor_mode; used_enable : enable_status);
   procedure setGestureGain(This        : in out APDS9960_Device;
                            Gain : UInt8);
   procedure setGestureLedDrive(This        : in out APDS9960_Device;
                                Drive : UInt8);
   procedure setGestureWaitTime(This        : in out APDS9960_Device;                                
                                Time : UInt8);
   procedure setGestureIntEnable(This : in out APDS9960_Device;                                
                                 Enable : enable_status);
   procedure setLedBoost(This : in out APDS9960_Device;                                
                         Boost : UInt8);
   procedure setGestureMode(This        : in out APDS9960_Device;
                            Enable : enable_status);
   
   procedure setLEDDrive(This        : in out APDS9960_Device;                                
                         Value : UInt8);
   procedure setProximityGain(This        : in out APDS9960_Device;                                
                              Value : UInt8);
   
   procedure Init (This        : in out APDS9960_Device);
   procedure Enable_Gesture_Sensor(This        : in out APDS9960_Device);
   procedure Disable_Gesture_Sensor(This       : in out APDS9960_Device);  
   
   function isGestureAvailable(This : in out APDS9960_Device) return Boolean;
   function readGesture(This : in out APDS9960_Device) return Gesture;
   
   -- Constants used by the program
   DEFAULT_GPENTH  : constant UInt8 := 40; 
   DEFAULT_GEXTH  : constant UInt8 := 30; 
   DEFAULT_GCONF1  : constant UInt8 := 16#40#; 
   DEFAULT_GGAIN  : constant UInt8 := 16#02#; 
   DEFAULT_GLDRIVE  : constant UInt8 := 16#00#; 
   DEFAULT_GWTIME  : constant UInt8 := 16#01#; 
   DEFAULT_GOFFSET  : constant UInt8 := 16#00#;
   DEFAULT_GPULSE  : constant UInt8 := 16#C9#; 
   DEFAULT_GCONF3  : constant UInt8 := 16#00#;
   DEFAULT_GIEN   : constant enable_status := ON;
   DEFAULT_BOOST  : constant UInt8 := 16#03#;
   DEFAULT_GESTURE_PPULSE : constant := 16#89#;
   FIFO_PAUSE_TIME : constant Natural := 30;
   APDS9960_GVALID : constant UInt8 := 2#00000001#;
   
   DEFAULT_ATIME : constant UInt8 := 219; 
   DEFAULT_WTIME : constant UInt8:= 246; 
   DEFAULT_PILT : constant UInt8:= 0;  
   DEFAULT_PIHT : constant UInt8:= 50; 
   DEFAULT_PROX_PPULSE : constant UInt8:= 16#87#;  
   DEFAULT_POFFSET_UR : constant UInt8:= 0; 
   DEFAULT_POFFSET_DL : constant UInt8:= 0; 
   DEFAULT_CONFIG1 : constant UInt8:= 16#60#;  
   DEFAULT_LDRIVE : constant UInt8:= 0; 
   DEFAULT_PGAIN : constant UInt8:= 2;  
   DEFAULT_PERS : constant UInt8:= 16#11#;
   DEFAULT_CONFIG2 : constant UInt8:= 16#01#;
   DEFAULT_CONFIG3 : constant UInt8:= 0;
   
private

--     type directions is (DIR_NONE, DIR_LEFT, DIR_RIGHT, DIR_UP, DIR_DOWN, 
--                         DIR_NEAR, DIR_FAR, DIR_ALL);
   
   type gesture_data_range is new Natural range 1 .. 32;
   type gesture_data_array is array (gesture_data_range) of UInt8;
   
   -- Empty fifo when new gesture is found successfully
   procedure empty_fifo(This        : in out APDS9960_Device;
                        fifo_level : Uint8);
   
   --  APDS9960 Registers
   --type Register is new UInt8;
   APDS9960_ENABLE : constant UInt8 := 16#80#;  --  
   APDS9960_ATIME : constant UInt8 := 16#81#;  --  
   APDS9960_WTIME : constant UInt8 := 16#83#;  --  
   APDS9960_AILTL : constant UInt8 := 16#84#;  --  
   APDS9960_AILTH : constant UInt8 := 16#85#;  -- 
   APDS9960_AIHTL : constant UInt8 := 16#86#;  -- 
   APDS9960_AIHTH : constant UInt8 := 16#87#;  -- 
   APDS9960_PILT : constant UInt8 := 16#89#;  --  
   APDS9960_PIHT : constant UInt8 := 16#8B#;  --  
   APDS9960_PERS : constant UInt8 := 16#8C#;  --  
   APDS9960_CONFIG1 : constant UInt8 := 16#8D#;  --  
   APDS9960_PPULSE : constant UInt8 := 16#8E#;  --  
   APDS9960_CONTROL : constant UInt8 := 16#8F#;  --  
   APDS9960_CONFIG2 : constant UInt8 := 16#90#;  --  
   APDS9960_ID : constant UInt8 := 16#92#;  --  
   APDS9960_STATUS : constant UInt8 := 16#93#;  --  
   APDS9960_CDATAL : constant UInt8 := 16#94#;  -- 
   APDS9960_CDATAH : constant UInt8 := 16#95#;  --  
   APDS9960_RDATAL : constant UInt8 := 16#96#;  --  
   APDS9960_RDATAH : constant UInt8 := 16#97#;  --  
   APDS9960_GDATAL : constant UInt8 := 16#98#;  --  
   APDS9960_GDATAH : constant UInt8 := 16#99#;  --  
   APDS9960_BDATAL : constant UInt8 := 16#9A#;  --  
   APDS9960_BDATAH : constant UInt8 := 16#9B#;  --  
   APDS9960_PDATA : constant UInt8 := 16#9C#;  --  
   APDS9960_POFFSET_UR : constant UInt8 := 16#9D#;  --  
   APDS9960_POFFSET_DL : constant UInt8 := 16#9E#;  --  
   APDS9960_CONFIG3 : constant UInt8 := 16#9F#;  -- 
   APDS9960_GPENTH : constant UInt8 := 16#A0#;  --  
   APDS9960_GEXTH : constant UInt8 := 16#A1#;  --  
   APDS9960_GCONF1 : constant UInt8 := 16#A2#;  -- 
   APDS9960_GCONF2 : constant UInt8 := 16#A3#;  -- 
   APDS9960_GOFFSET_U : constant UInt8 := 16#A4#;  --  
   APDS9960_GOFFSET_D : constant UInt8 := 16#A5#;  --  
   APDS9960_GOFFSET_L : constant UInt8 := 16#A7#;  -- 
   APDS9960_GOFFSET_R : constant UInt8 := 16#A9#;  -- 
   APDS9960_GPULSE : constant UInt8 := 16#A6#;  --  
   APDS9960_GCONF3 : constant UInt8 := 16#AA#;  -- 
   APDS9960_GCONF4 : constant UInt8 := 16#AB#;  --
   APDS9960_GFLVL : constant UInt8 := 16#AE#;  -- 
   APDS9960_GSTATUS : constant UInt8 := 16#AF#;  --  
   APDS9960_IFORCE : constant UInt8 := 16#E4#;  --  
   APDS9960_PICLEAR : constant UInt8 := 16#E5#;  --  
   APDS9960_CICLEAR : constant UInt8 := 16#E6#;  --  
   APDS9960_AICLEAR : constant UInt8 := 16#E7#;  -- 
   APDS9960_GFIFO_U : constant UInt8 := 16#FC#;  -- 
   APDS9960_GFIFO_D : constant UInt8 := 16#FD#;  -- 
   APDS9960_GFIFO_L : constant UInt8 := 16#FE#;  --  
   APDS9960_GFIFO_R : constant UInt8 := 16#FF#;  -- 
   
   procedure I2C_Write(This  : in out APDS9960_Device;
                       Reg   : UInt8;
                       Value : UInt8;
                       Status : out I2C_Status);
   
   function I2C_Read (This : in out APDS9960_Device;
                      Reg  : UInt8;
                      Status : out I2C_Status)
                      return UInt8;
   
   procedure I2C_Read_Buffer(This  : in out APDS9960_Device;
                             Reg   : UInt8;
                             Value : out I2C_Data;
                             Status : out I2C_Status);   
   
   type APDS9960_Device (Port : not null Any_I2C_Port;
                        Time : not null HAL.Time.Any_Delays) is 
     tagged limited record 
      Initialized : Boolean := False;
      Last_Status_I2C : I2C_Status;     
   end record;

end apds9960_gesture;
