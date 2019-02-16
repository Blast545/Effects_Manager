-- Change pitch

with Interfaces;           use Interfaces;

package body Pitch is

   overriding
   procedure Reset_Variables (This : in out Pitch_Effect)
   is
   begin
      null;
   end Reset_Variables;

   overriding
   procedure Process_Audio_Block( This : in out Pitch_Effect;
                                  Samples_To_Process : in out Audio_Buffer)
   is
      buffered : Float := 0.0;
      index : Natural := 1;
      read_variable : Boolean := False;
      output_processed : Audio_Buffer(1 .. Samples_To_Process'Last) := (others => 0);
   begin
      for sampled_data of Samples_To_Process loop
         -- Avergae two samples, and leave a sample output in 0
         -- Chuncks of data will have half the size of the input
         if (read_variable) then
            buffered := (buffered + Float(sampled_data))/2.0;
            output_processed(index) := Integer_16(buffered);
            index := index + 1;
         else
            buffered := Float(sampled_data);
         end if;
         read_variable := not read_variable;

      end loop;
      Samples_To_Process := output_processed;
   end Process_Audio_Block;

end Pitch;
