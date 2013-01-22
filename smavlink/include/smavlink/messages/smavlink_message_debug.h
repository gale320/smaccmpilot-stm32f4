/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#ifndef __SMAVLINK_MESSAGE_DEBUG_H__
#define __SMAVLINK_MESSAGE_DEBUG_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct debug_msg {
    uint32_t time_boot_ms;
    float value;
    uint8_t ind;
};
void smavlink_send_debug(struct debug_msg* n_var0,
                         struct smavlink_out_channel* n_var1,
                         struct smavlink_system* n_var2);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_DEBUG_H__ */