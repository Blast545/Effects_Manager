-- Voice effect, used to filter noise, and produce as output
-- the voice of the person filtered for better audio

with HAL.Audio_Effect;  use HAL.Audio_Effect;
with HAL.Audio;         use HAL.Audio;
--with Interfaces;        use Interfaces;

package Echo is

   type Echo_Effect is limited new Audio_Effect with private;

   overriding
   procedure Reset_Variables (This : in out Echo_Effect);

   overriding
   procedure Process_Audio_Block( This : in out Echo_Effect;
                                  Samples_To_Process : in out Audio_Buffer);
   Effect_Name : constant String := "Echo Effect";

private

   -- Sample Rate: 48000
   -- To get 1 second delay, at least 48000 samples are required to be
   -- saved
   block_a : constant Float := 0.995;
   input_gain : constant Float := 1.0;
   number_of_samples : constant Natural := 48000;
   output_gain : constant Float := 5.0;

   type Echo_Effect is
   limited new Audio_Effect with record
      saved_samples : Audio_Buffer (1 .. number_of_samples);
      dc_x_n1 : Float := 0.0;
      dc_y_n1 : Float := 0.0;
   end record;

end Echo;
