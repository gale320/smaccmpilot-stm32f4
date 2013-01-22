/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#include <out.h>
#include <smavlink/pack.h>
#include "smavlink_message_sys_status.h"
void smavlink_send_sys_status(struct sys_status_msg* n_var0,
                              struct smavlink_out_channel* n_var1,
                              struct smavlink_system* n_var2)
{
    uint8_t n_local0[31U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[31U] = &n_local0;
    uint32_t n_deref2 = *&n_var0->onboard_control_sensors_present;
    
    smavlink_pack_uint32_t(n_ref1, 0U, n_deref2);
    
    uint32_t n_deref3 = *&n_var0->onboard_control_sensors_enabled;
    
    smavlink_pack_uint32_t(n_ref1, 4U, n_deref3);
    
    uint32_t n_deref4 = *&n_var0->onboard_control_sensors_health;
    
    smavlink_pack_uint32_t(n_ref1, 8U, n_deref4);
    
    uint16_t n_deref5 = *&n_var0->load;
    
    smavlink_pack_uint16_t(n_ref1, 12U, n_deref5);
    
    uint16_t n_deref6 = *&n_var0->voltage_battery;
    
    smavlink_pack_uint16_t(n_ref1, 14U, n_deref6);
    
    int16_t n_deref7 = *&n_var0->current_battery;
    
    smavlink_pack_int16_t(n_ref1, 16U, n_deref7);
    
    uint16_t n_deref8 = *&n_var0->drop_rate_comm;
    
    smavlink_pack_uint16_t(n_ref1, 18U, n_deref8);
    
    uint16_t n_deref9 = *&n_var0->errors_comm;
    
    smavlink_pack_uint16_t(n_ref1, 20U, n_deref9);
    
    uint16_t n_deref10 = *&n_var0->errors_count1;
    
    smavlink_pack_uint16_t(n_ref1, 22U, n_deref10);
    
    uint16_t n_deref11 = *&n_var0->errors_count2;
    
    smavlink_pack_uint16_t(n_ref1, 24U, n_deref11);
    
    uint16_t n_deref12 = *&n_var0->errors_count3;
    
    smavlink_pack_uint16_t(n_ref1, 26U, n_deref12);
    
    uint16_t n_deref13 = *&n_var0->errors_count4;
    
    smavlink_pack_uint16_t(n_ref1, 28U, n_deref13);
    
    int8_t n_deref14 = *&n_var0->battery_remaining;
    
    smavlink_pack_int8_t(n_ref1, 30U, n_deref14);
    smavlink_send_ivory(n_var1, n_var2, 1U, n_ref1, 31U, 124U);
    return;
}
