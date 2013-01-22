/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_file_transfer_start.h"
void smavlink_send_file_transfer_start(struct file_transfer_start_msg* n_var0,
                                       struct smavlink_out_channel* n_var1,
                                       struct smavlink_system* n_var2)
{
    uint8_t n_local0[254U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[254U] = &n_local0;
    uint64_t n_deref2 = *&n_var0->transfer_uid;
    
    smavlink_pack_uint64_t(n_ref1, 0U, n_deref2);
    
    uint32_t n_deref3 = *&n_var0->file_size;
    
    smavlink_pack_uint32_t(n_ref1, 8U, n_deref3);
    
    uint8_t n_deref4 = *&n_var0->direction;
    
    smavlink_pack_uint8_t(n_ref1, 252U, n_deref4);
    
    uint8_t n_deref5 = *&n_var0->flags;
    
    smavlink_pack_uint8_t(n_ref1, 253U, n_deref5);
    
    uint8_t(* n_let6)[240U] = &n_var0->dest_path;
    uint8_t n_ix7 = 0U % 240U;
    
    for (; n_ix7 < 239U % 240U; n_ix7 = n_ix7 + 1U % 240U) {
        uint8_t n_deref8 = *&*n_let6[n_ix7];
        
        smavlink_pack_uint8_t(n_ref1, 12U + n_ix7, n_deref8);
    }
    smavlink_send_ivory(n_var1, n_var2, 110U, n_ref1, 254U, 235U);
    return;
}
