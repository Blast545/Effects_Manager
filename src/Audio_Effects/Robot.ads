-- Voice effect, used to filter noise, and produce as output
-- the voice of the person filtered for better audio

with HAL.Audio_Effect;  use HAL.Audio_Effect;
with HAL.Audio;         use HAL.Audio;
--with Ada; use Ada;
with Ada.Numerics;
with HAL;

package Robot is

   type Robot_Effect is limited new Audio_Effect with private;

   overriding
   procedure Reset_Variables (This : in out Robot_Effect);

   overriding
   procedure Process_Audio_Block( This : in out Robot_Effect;
                                  Samples_To_Process : in out Audio_Buffer);
   Effect_Name : constant String := "Robotic Voice";

private

   block_a : constant Float := 0.995;
   input_gain : constant Float := 1.0;
   output_gain : constant Float := 5.0;
   modulation_freq : constant Float:= 200.0;
   sampling_freq : constant Float := 48000.0;
   freq_ratio : constant Float := modulation_freq/sampling_freq;
   Radians_Cycle : constant Float := 2.0 * Ada.Numerics.Pi;

   type Robot_Effect is
   limited new Audio_Effect with record
      --current_angle : Float := 0.0;
      current_n :  HAL.UInt16 := 0;
      dc_y_n1 : Float := 0.0;
      dc_x_n1 : Float := 0.0;
   end record;

end Robot;
