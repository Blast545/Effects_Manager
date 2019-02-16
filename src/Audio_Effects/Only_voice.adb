-- Simple effect: remove noise
-- Links to theory used for these effects:
--

with Interfaces;           use Interfaces;

package body Only_Voice is

   overriding
   procedure Reset_Variables (This : in out Only_Voice_Effect)
   is
   begin
--        This.wNm1 := 0.0;
--        This.wNm2 := 0.0;
      This.dc_x_n1 := 0.0;
      This.dc_y_n1 := 0.0;

      This.f1_x_n1 := 0.0;
      This.f1_x_n2 := 0.0;
      This.f1_y_n1 := 0.0;
      This.f1_y_n2 := 0.0;

      This.f2_x_n1 := 0.0;
      This.f2_x_n2 := 0.0;
      This.f2_y_n1 := 0.0;
      This.f2_y_n2 := 0.0;
   end Reset_Variables;

   overriding
   procedure Process_Audio_Block( This : in out Only_Voice_Effect;
                                  Samples_To_Process : in out Audio_Buffer)
   is
      in_out_Value : Float := 0.0;
      xn_value : Float := 0.0;

      b0 : constant Float :=  0.22960342423928587;
      b1 : constant Float :=  0.45920684847857174;
      b2 : constant Float :=  0.22960342423928587;
      a1 : constant Float :=  0.3463892793340412;
      a2 : constant Float :=  -0.2567914170944416;

   begin
      for sampled_data of Samples_To_Process loop
         -- Save current sample value
         -- Current_Sample := sampled_data;

         -- DC blocking filter
         in_out_Value := Float(sampled_data) * input_gain;
         in_out_Value := in_out_Value - this.dc_x_n1 + block_a * This.dc_y_n1;
         This.dc_y_n1 := in_out_Value;
         This.dc_x_n1 := Float(sampled_data);

         -- F1
         xn_value := in_out_Value;
         in_out_Value := b0*xn_value + b1*This.f1_x_n1 + b2*This.f1_x_n2;
         in_out_Value := in_out_Value - a1*This.f1_y_n1 - a2*This.f1_y_n2;
         This.f1_y_n2 := This.f1_y_n1;
         This.f1_y_n1 := in_out_Value;
         This.f1_x_n2 := This.f1_x_n1;
         This.f1_x_n1 := xn_value;

         -- Save the data to the array of processed samples
         -- (same input array is used as output)
         in_out_Value := in_out_Value * 15.0;
         sampled_data := Integer_16(in_out_Value);

      end loop;

   end Process_Audio_Block;

end Only_Voice;

-- IIR biquad filter, form 2
--           -- Amplify the signal before filtering
--           in_out_Value := (Float(sampled_data) - 2048.0) * input_gain;
--
--           -- Apply the filter variables
--           wn_aux_value := in_out_Value - a1*This.wNm1 - a2*This.wNm2;
--           in_out_Value := b0*wn_aux_value + b1*This.wNm1 + b2*This.wNm2;
--
--           -- Save the current filter variables
--           This.wNm2 := This.wNm1;
--           This.wNm1 := wn_aux_value;
--
--           -- Apply the output gain
--           in_out_Value := in_out_Value * output_gain;

         -- Low pass chebishev filter, cut freq: 6kHz
         -- yn := x0*b0 + x1*b1 + x2*b2 - a1*y1 - a2*y2
         -- F1
--           xn_value := in_out_Value;
--           in_out_Value := xn_value + f1_b1*This.f1_x_n1 + This.f1_x_n2;
--           in_out_Value := in_out_Value - f1_a1*This.f1_y_n1 - f1_a2*This.f1_y_n2;
--           This.f1_y_n2 := This.f1_y_n1;
--           This.f1_y_n1 := in_out_Value;
--           This.f1_x_n2 := This.f1_x_n1;
--           This.f1_x_n1 := xn_value;
--
--
--           -- F2
--           xn_value := in_out_Value;
--           in_out_Value := xn_value + f2_b1*This.f2_x_n1 + This.f2_x_n2;
--           in_out_Value := in_out_Value - f2_a1*This.f2_y_n1 - f2_a2*This.f2_y_n2;
--           This.f2_y_n2 := This.f2_y_n1;
--           This.f2_y_n1 := in_out_Value;
--           This.f2_x_n2 := This.f2_x_n1;
         --           This.f2_x_n1 := xn_value;

         -- Filters have a 1/100 gain, increase the output of the signal
         -- before moving it to the output
         --in_out_Value := in_out_Value;
