/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_set_quad_swarm_roll_pitch_yaw_thrust.h"
void smavlink_send_set_quad_swarm_roll_pitch_yaw_thrust(struct set_quad_swarm_roll_pitch_yaw_thrust_msg* n_var0,
                                                        struct smavlink_out_channel* n_var1,
                                                        struct smavlink_system* n_var2)
{
    uint8_t n_local0[34U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[34U] = &n_local0;
    uint8_t n_deref2 = *&n_var0->group;
    
    smavlink_pack_uint8_t(n_ref1, 32U, n_deref2);
    
    uint8_t n_deref3 = *&n_var0->mode;
    
    smavlink_pack_uint8_t(n_ref1, 33U, n_deref3);
    
    int16_t(* n_let4)[4U] = &n_var0->roll;
    uint8_t n_ix5 = 0U % 4U;
    
    for (; n_ix5 < 3U % 4U; n_ix5 = n_ix5 + 1U % 4U) {
        int16_t n_deref6 = *&*n_let4[n_ix5];
        
        smavlink_pack_int16_t(n_ref1, 0U + n_ix5, n_deref6);
    }
    
    int16_t(* n_let7)[4U] = &n_var0->pitch;
    uint8_t n_ix8 = 0U % 4U;
    
    for (; n_ix8 < 3U % 4U; n_ix8 = n_ix8 + 1U % 4U) {
        int16_t n_deref9 = *&*n_let7[n_ix8];
        
        smavlink_pack_int16_t(n_ref1, 8U + n_ix8, n_deref9);
    }
    
    int16_t(* n_let10)[4U] = &n_var0->yaw;
    uint8_t n_ix11 = 0U % 4U;
    
    for (; n_ix11 < 3U % 4U; n_ix11 = n_ix11 + 1U % 4U) {
        int16_t n_deref12 = *&*n_let10[n_ix11];
        
        smavlink_pack_int16_t(n_ref1, 16U + n_ix11, n_deref12);
    }
    
    uint16_t(* n_let13)[4U] = &n_var0->thrust;
    uint8_t n_ix14 = 0U % 4U;
    
    for (; n_ix14 < 3U % 4U; n_ix14 = n_ix14 + 1U % 4U) {
        uint16_t n_deref15 = *&*n_let13[n_ix14];
        
        smavlink_pack_uint16_t(n_ref1, 24U + n_ix14, n_deref15);
    }
    smavlink_send_ivory(n_var1, n_var2, 61U, n_ref1, 34U, 240U);
    return;
}
