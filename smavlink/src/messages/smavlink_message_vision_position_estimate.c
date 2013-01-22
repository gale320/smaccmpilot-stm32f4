/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_vision_position_estimate.h"
void smavlink_send_vision_position_estimate(struct vision_position_estimate_msg* n_var0,
                                            struct smavlink_out_channel* n_var1,
                                            struct smavlink_system* n_var2)
{
    uint8_t n_local0[32U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[32U] = &n_local0;
    uint64_t n_deref2 = *&n_var0->usec;
    
    smavlink_pack_uint64_t(n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->x;
    
    smavlink_pack_float(n_ref1, 8U, n_deref3);
    
    float n_deref4 = *&n_var0->y;
    
    smavlink_pack_float(n_ref1, 12U, n_deref4);
    
    float n_deref5 = *&n_var0->z;
    
    smavlink_pack_float(n_ref1, 16U, n_deref5);
    
    float n_deref6 = *&n_var0->roll;
    
    smavlink_pack_float(n_ref1, 20U, n_deref6);
    
    float n_deref7 = *&n_var0->pitch;
    
    smavlink_pack_float(n_ref1, 24U, n_deref7);
    
    float n_deref8 = *&n_var0->yaw;
    
    smavlink_pack_float(n_ref1, 28U, n_deref8);
    smavlink_send_ivory(n_var1, n_var2, 102U, n_ref1, 32U, 158U);
    return;
}
