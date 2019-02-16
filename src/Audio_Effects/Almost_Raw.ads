-- Voice effect, used to hear the input of the mic without
-- further processing

with HAL.Audio_Effect;  use HAL.Audio_Effect;
with HAL.Audio;         use HAL.Audio;

package Almost_Raw is

   type Almost_Raw_Effect is limited new Audio_Effect with private;

   overriding
   procedure Reset_Variables (This : in out Almost_Raw_Effect);

   overriding
   procedure Process_Audio_Block( This : in out Almost_Raw_Effect;
                                  Samples_To_Process : in out Audio_Buffer);
   Effect_Name : constant String := "Almost Raw";

private

   offset_to_remove : constant Float := 2048.0;
   input_gain : constant Float := 10.0;

   type Almost_Raw_Effect is
   limited new Audio_Effect with record
      null;
   end record;

end Almost_Raw;
