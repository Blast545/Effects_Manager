------------------------------------------------------------------------------
--                                                                          --
--                 Copyright (C) 2015-2016, AdaCore                         --
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

--with STM32.Device;  use STM32.Device;
--with STM32.ADC; use STM32.ADC;
--with STM32.Board;
--with Custom_Board; use Custom_Board;
with STM32.ADC; use STM32.ADC;
with Interfaces; use Interfaces;

package body ADC_Interrupt_Handling is

   -------------
   -- Handler --
   -------------

   protected body Handler is

      -----------------
      -- IRQ_Handler --
      -----------------

      procedure IRQ_Handler is
      begin
         if Status (ADC_2, Regular_Channel_Conversion_Complete) then
            if Interrupt_Enabled (ADC_2, Regular_Channel_Conversion_Complete) then
               Clear_Interrupt_Pending (ADC_2, Regular_Channel_Conversion_Complete);

               -- Save the sample to the samples array
              -- Sampled_Data(Current_Index_Samples) := Conversion_Value (VMic.ADC.all);
               Samples_Buffer (Current_Index_Samples) := Integer_16(Conversion_Value (VMic.ADC.all));

               -- Check if buffer is full, else index is increased
               if(Current_Index_Samples = Audio_Index'Last) then
                  Set_True(Completed_Set_Samples);
                  Current_Index_Samples := Audio_Index'First;
               else
                  Current_Index_Samples := Current_Index_Samples + 1;
               end if;

            end if;
         end if;
      end IRQ_Handler;

   end Handler;

end ADC_Interrupt_Handling;
