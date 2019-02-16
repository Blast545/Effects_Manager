-- Simple effect: remove noise
-- Links to theory used for these effects:
--

with Interfaces;           use Interfaces;

package body Echo is

   overriding
   procedure Reset_Variables (This : in out Echo_Effect)
   is
   begin
      This.saved_samples := (others => 0);
      This.dc_x_n1 := 0.0;
      This.dc_y_n1 := 0.0;
   end Reset_Variables;

   overriding
   procedure Process_Audio_Block( This : in out Echo_Effect;
                                  Samples_To_Process : in out Audio_Buffer)
   is
      in_out_value : Float := 0.0;
      echo_value : Float := 0.0;
      echo_value2 : Float := 0.0;
      data_to_save : Audio_Buffer (1 .. Samples_To_Process'Last);
   begin

      for Index in Samples_To_Process'Range loop
         -- DC blocking filter
         in_out_Value := Float(Samples_To_Process(Index)) * input_gain;
         in_out_Value := in_out_Value - this.dc_x_n1 + block_a * This.dc_y_n1;
         This.dc_y_n1 := in_out_Value;
         This.dc_x_n1 := Float(Samples_To_Process(Index));
         data_to_save(Index) := Integer_16(in_out_value);



         -- Remove offset from current sample and saved
         echo_value := Float(this.saved_samples(Index));
         echo_value2 := Float(this.saved_samples(Index+22400));

         -- Add the echo to current sample
         in_out_value := in_out_value + echo_value2/1.2 + echo_value/1.7;

         -- Apply signal gain
         in_out_value := in_out_value * output_gain;

         Samples_To_Process(Index) := Integer_16(in_out_value);
      end loop;

      -- Erase old values from samples buffer
      This.saved_samples(1 .. This.saved_samples'Last-Samples_To_Process'Last) := This.saved_samples(Samples_To_Process'Last+1 .. This.saved_samples'Last);
      -- Save new samples
      This.saved_samples(This.saved_samples'Last -Samples_To_Process'Last +1 .. This.saved_samples'Last) := data_to_save;

   end Process_Audio_Block;

end Echo;
