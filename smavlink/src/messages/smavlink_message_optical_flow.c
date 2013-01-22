/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_optical_flow.h"
void smavlink_send_optical_flow(struct optical_flow_msg* n_var0,
                                struct smavlink_out_channel* n_var1,
                                struct smavlink_system* n_var2)
{
    uint8_t n_local0[26U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[26U] = &n_local0;
    uint64_t n_deref2 = *&n_var0->time_usec;
    
    smavlink_pack_uint64_t(n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->flow_comp_m_x;
    
    smavlink_pack_float(n_ref1, 8U, n_deref3);
    
    float n_deref4 = *&n_var0->flow_comp_m_y;
    
    smavlink_pack_float(n_ref1, 12U, n_deref4);
    
    float n_deref5 = *&n_var0->ground_distance;
    
    smavlink_pack_float(n_ref1, 16U, n_deref5);
    
    int16_t n_deref6 = *&n_var0->flow_x;
    
    smavlink_pack_int16_t(n_ref1, 20U, n_deref6);
    
    int16_t n_deref7 = *&n_var0->flow_y;
    
    smavlink_pack_int16_t(n_ref1, 22U, n_deref7);
    
    uint8_t n_deref8 = *&n_var0->sensor_id;
    
    smavlink_pack_uint8_t(n_ref1, 24U, n_deref8);
    
    uint8_t n_deref9 = *&n_var0->quality;
    
    smavlink_pack_uint8_t(n_ref1, 25U, n_deref9);
    smavlink_send_ivory(n_var1, n_var2, 100U, n_ref1, 26U, 175U);
    return;
}
