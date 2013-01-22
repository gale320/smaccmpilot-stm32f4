/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_raw_imu.h"
void smavlink_send_raw_imu(struct raw_imu_msg* n_var0,
                           struct smavlink_out_channel* n_var1,
                           struct smavlink_system* n_var2)
{
    uint8_t n_local0[26U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[26U] = &n_local0;
    uint64_t n_deref2 = *&n_var0->time_usec;
    
    smavlink_pack_uint64_t(n_ref1, 0U, n_deref2);
    
    int16_t n_deref3 = *&n_var0->xacc;
    
    smavlink_pack_int16_t(n_ref1, 8U, n_deref3);
    
    int16_t n_deref4 = *&n_var0->yacc;
    
    smavlink_pack_int16_t(n_ref1, 10U, n_deref4);
    
    int16_t n_deref5 = *&n_var0->zacc;
    
    smavlink_pack_int16_t(n_ref1, 12U, n_deref5);
    
    int16_t n_deref6 = *&n_var0->xgyro;
    
    smavlink_pack_int16_t(n_ref1, 14U, n_deref6);
    
    int16_t n_deref7 = *&n_var0->ygyro;
    
    smavlink_pack_int16_t(n_ref1, 16U, n_deref7);
    
    int16_t n_deref8 = *&n_var0->zgyro;
    
    smavlink_pack_int16_t(n_ref1, 18U, n_deref8);
    
    int16_t n_deref9 = *&n_var0->xmag;
    
    smavlink_pack_int16_t(n_ref1, 20U, n_deref9);
    
    int16_t n_deref10 = *&n_var0->ymag;
    
    smavlink_pack_int16_t(n_ref1, 22U, n_deref10);
    
    int16_t n_deref11 = *&n_var0->zmag;
    
    smavlink_pack_int16_t(n_ref1, 24U, n_deref11);
    smavlink_send_ivory(n_var1, n_var2, 27U, n_ref1, 26U, 144U);
    return;
}
