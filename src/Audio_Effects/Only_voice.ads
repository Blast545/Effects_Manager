-- Voice effect, used to filter noise, and produce as output
-- the voice of the person filtered for better audio

with HAL.Audio_Effect;  use HAL.Audio_Effect;
with HAL.Audio;         use HAL.Audio;
--with Interfaces;        use Interfaces;

package Only_Voice is

   type Only_Voice_Effect is limited new Audio_Effect with private;

   overriding
   procedure Reset_Variables (This : in out Only_Voice_Effect);

   overriding
   procedure Process_Audio_Block( This : in out Only_Voice_Effect;
                                  Samples_To_Process : in out Audio_Buffer);
   Effect_Name : constant String := "Pure Voice";

private

   block_a : constant Float := 0.995;
   input_gain : constant Float := 1.0;
   output_gain : constant Float := 15.0;

   type Only_Voice_Effect is
   limited new Audio_Effect with record
      dc_x_n1 : Float := 0.0;
      dc_y_n1 : Float := 0.0;

      f1_x_n1 : Float := 0.0;
      f1_x_n2 : Float := 0.0;
      f1_y_n1 : Float := 0.0;
      f1_y_n2 : Float := 0.0;

      f2_x_n1 : Float := 0.0;
      f2_x_n2 : Float := 0.0;
      f2_y_n1 : Float := 0.0;
      f2_y_n2 : Float := 0.0;
     end record;

end Only_Voice;
