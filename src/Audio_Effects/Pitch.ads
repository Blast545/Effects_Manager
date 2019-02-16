-- Not ready to be used
with HAL.Audio_Effect;  use HAL.Audio_Effect;
with HAL.Audio;         use HAL.Audio;
--with Interfaces;        use Interfaces;

package Pitch is

   type Pitch_Effect is limited new Audio_Effect with private;

   overriding
   procedure Reset_Variables (This : in out Pitch_Effect);

   overriding
   procedure Process_Audio_Block( This : in out Pitch_Effect;
                                  Samples_To_Process : in out Audio_Buffer);
   Effect_Name : constant String := "High pitch";

private

   output_gain : constant Float := 5.0;

   type Pitch_Effect is
   limited new Audio_Effect with record
      null;
     end record;

end Pitch;
