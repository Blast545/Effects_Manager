-- HAL file used to describe the basics of an effect object
--with Interfaces; use Interfaces;
with Hal.Audio; use Hal.Audio;

package HAL.Audio_Effect is
   
   type Audio_Effect is limited interface;
   
   procedure Reset_Variables( This : in out Audio_Effect) is abstract;
   
   procedure Process_Audio_Block( This : in out Audio_Effect; 
                                  Samples_To_Process : in out Audio_Buffer)
   is abstract;
   
end HAL.Audio_Effect;
