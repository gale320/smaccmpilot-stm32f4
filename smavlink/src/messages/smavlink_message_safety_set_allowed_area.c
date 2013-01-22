/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_safety_set_allowed_area.h"
void smavlink_send_safety_set_allowed_area(struct safety_set_allowed_area_msg* n_var0,
                                           struct smavlink_out_channel* n_var1,
                                           struct smavlink_system* n_var2)
{
    uint8_t n_local0[27U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[27U] = &n_local0;
    float n_deref2 = *&n_var0->p1x;
    
    smavlink_pack_float(n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->p1y;
    
    smavlink_pack_float(n_ref1, 4U, n_deref3);
    
    float n_deref4 = *&n_var0->p1z;
    
    smavlink_pack_float(n_ref1, 8U, n_deref4);
    
    float n_deref5 = *&n_var0->p2x;
    
    smavlink_pack_float(n_ref1, 12U, n_deref5);
    
    float n_deref6 = *&n_var0->p2y;
    
    smavlink_pack_float(n_ref1, 16U, n_deref6);
    
    float n_deref7 = *&n_var0->p2z;
    
    smavlink_pack_float(n_ref1, 20U, n_deref7);
    
    uint8_t n_deref8 = *&n_var0->target_system;
    
    smavlink_pack_uint8_t(n_ref1, 24U, n_deref8);
    
    uint8_t n_deref9 = *&n_var0->target_component;
    
    smavlink_pack_uint8_t(n_ref1, 25U, n_deref9);
    
    uint8_t n_deref10 = *&n_var0->frame;
    
    smavlink_pack_uint8_t(n_ref1, 26U, n_deref10);
    smavlink_send_ivory(n_var1, n_var2, 54U, n_ref1, 27U, 15U);
    return;
}
