/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#ifndef __SMAVLINK_MESSAGE_CHANGE_OPERATOR_CONTROL_H__
#define __SMAVLINK_MESSAGE_CHANGE_OPERATOR_CONTROL_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct change_operator_control_msg {
    uint8_t target_system;
    uint8_t control_request;
    uint8_t version;
    uint8_t passkey[25U];
};
void smavlink_send_change_operator_control(struct change_operator_control_msg* n_var0,
                                           struct smavlink_out_channel* n_var1,
                                           struct smavlink_system* n_var2);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_CHANGE_OPERATOR_CONTROL_H__ */