/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_request_data_stream.h"
void smavlink_send_request_data_stream(struct request_data_stream_msg* n_var0,
                                       struct smavlink_out_channel* n_var1,
                                       struct smavlink_system* n_var2)
{
    uint8_t n_local0[6U] = {0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[6U] = &n_local0;
    uint16_t n_deref2 = *&n_var0->req_message_rate;
    
    smavlink_pack_uint16_t(n_ref1, 0U, n_deref2);
    
    uint8_t n_deref3 = *&n_var0->target_system;
    
    smavlink_pack_uint8_t(n_ref1, 2U, n_deref3);
    
    uint8_t n_deref4 = *&n_var0->target_component;
    
    smavlink_pack_uint8_t(n_ref1, 3U, n_deref4);
    
    uint8_t n_deref5 = *&n_var0->req_stream_id;
    
    smavlink_pack_uint8_t(n_ref1, 4U, n_deref5);
    
    uint8_t n_deref6 = *&n_var0->start_stop;
    
    smavlink_pack_uint8_t(n_ref1, 5U, n_deref6);
    smavlink_send_ivory(n_var1, n_var2, 66U, n_ref1, 6U, 148U);
    return;
}
