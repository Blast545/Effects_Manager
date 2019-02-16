------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2015-2016, AdaCore                     --
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
--     3. Neither the name of the copyright holder nor the names of its     --
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
--                                                                          --
------------------------------------------------------------------------------

--  This version of the LCH only toggles the Red LED.

--  Note this version is for use with the ravenscar-sfp runtime.

with STM32.Board;   use STM32.Board;
with Ada.Real_Time; use Ada.Real_Time;
with Custom_Board; use Custom_Board;
with ILI9341_Extended; use ILI9341_Extended;
with HAL; use HAL;
with System.Address_Image;

package body Last_Chance_Handler is

   -------------------------
   -- Last_Chance_Handler --
   -------------------------

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      --pragma Unreferenced (Msg, Line);
      --pragma Unreferenced(Msg);

   begin
      Initialize_LEDs;

      All_LEDs_Off;

      Screen.Fill(Color => Black);

      Screen.Print_String(X                => 5,
                          Y                => 30,
                          Text             => "Last chance handler",
                          Foreground_Color => White,
                          Background_Color => Black);

      Screen.Print_String(X                => 30,
                          Y                => 50,
                          Text             => System.Address_Image(A => Msg),
                          Foreground_Color => White,
                          Background_Color => Black);

      Screen.Print_String(X                => 30,
                          Y                => 70,
                          Text             => UInt32(Line)'Img,
                          Foreground_Color => White,
                          Background_Color => Black);


      --  No-return procedure...
      loop
         Toggle (LCH_LED);
         delay until Clock + Milliseconds (500);
      end loop;
   end Last_Chance_Handler;

end Last_Chance_Handler;
