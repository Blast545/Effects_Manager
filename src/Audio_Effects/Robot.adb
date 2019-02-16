-- Robotic voice
--

--with Interfaces;           use Interfaces;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with HAL; use HAL;
with Interfaces; use Interfaces;

package body Robot is

   overriding
   procedure Reset_Variables (This : in out Robot_Effect)
   is
   begin
      --this.current_angle := 0.0;
      this.current_n := 0;
      this.dc_y_n1 := 0.0;
      this.dc_x_n1 := 0.0;
   end Reset_Variables;

   overriding
   procedure Process_Audio_Block( This : in out Robot_Effect;
                                  Samples_To_Process : in out Audio_Buffer)
   is
      current_angle : Float := 0.0;
      in_out_Value : Float := 0.0;
   begin

      for sampled_data of Samples_To_Process loop
         -- DC blocking filter
         in_out_Value := Float(sampled_data) * input_gain;
         in_out_Value := in_out_Value - this.dc_x_n1 + block_a * This.dc_y_n1;
         This.dc_y_n1 := in_out_Value;
         This.dc_x_n1 := Float(sampled_data);

         -- Apply Alien effect
         current_angle := Radians_Cycle * freq_ratio * Float(this.current_n);
         in_out_Value := Sin (current_angle, Radians_Cycle) * in_out_Value;
         this.current_n := This.current_n + 1;

         -- Apply output gain:
         in_out_Value := in_out_Value * output_gain;
         -- Save to the output
         sampled_data := Integer_16(in_out_Value);

      end loop;

   end Process_Audio_Block;

end Robot;
