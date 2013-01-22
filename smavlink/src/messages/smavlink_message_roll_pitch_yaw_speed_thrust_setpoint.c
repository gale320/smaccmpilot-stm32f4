/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_roll_pitch_yaw_speed_thrust_setpoint.h"
void smavlink_send_roll_pitch_yaw_speed_thrust_setpoint(struct roll_pitch_yaw_speed_thrust_setpoint_msg* n_var0,
                                                        struct smavlink_out_channel* n_var1,
                                                        struct smavlink_system* n_var2)
{
    uint8_t n_local0[20U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0};
    uint8_t(* n_ref1)[20U] = &n_local0;
    uint32_t n_deref2 = *&n_var0->time_boot_ms;
    
    smavlink_pack_uint32_t(n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->roll_speed;
    
    smavlink_pack_float(n_ref1, 4U, n_deref3);
    
    float n_deref4 = *&n_var0->pitch_speed;
    
    smavlink_pack_float(n_ref1, 8U, n_deref4);
    
    float n_deref5 = *&n_var0->yaw_speed;
    
    smavlink_pack_float(n_ref1, 12U, n_deref5);
    
    float n_deref6 = *&n_var0->thrust;
    
    smavlink_pack_float(n_ref1, 16U, n_deref6);
    smavlink_send_ivory(n_var1, n_var2, 59U, n_ref1, 20U, 238U);
    return;
}
