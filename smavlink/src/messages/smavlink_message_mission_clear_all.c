/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_mission_clear_all.h"
void smavlink_send_mission_clear_all(struct mission_clear_all_msg* n_var0,
                                     struct smavlink_out_channel* n_var1,
                                     struct smavlink_system* n_var2)
{
    uint8_t n_local0[2U] = {0, 0};
    uint8_t(* n_ref1)[2U] = &n_local0;
    uint8_t n_deref2 = *&n_var0->target_system;
    
    smavlink_pack_uint8_t(n_ref1, 0U, n_deref2);
    
    uint8_t n_deref3 = *&n_var0->target_component;
    
    smavlink_pack_uint8_t(n_ref1, 1U, n_deref3);
    smavlink_send_ivory(n_var1, n_var2, 45U, n_ref1, 2U, 232U);
    return;
}
