/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#ifndef __SMAVLINK_MESSAGE_SETPOINT_6DOF_H__
#define __SMAVLINK_MESSAGE_SETPOINT_6DOF_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct setpoint_6dof_msg {
    float trans_x;
    float trans_y;
    float trans_z;
    float rot_x;
    float rot_y;
    float rot_z;
    uint8_t target_system;
};
void smavlink_send_setpoint_6dof(struct setpoint_6dof_msg* n_var0,
                                 struct smavlink_out_channel* n_var1,
                                 struct smavlink_system* n_var2);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_SETPOINT_6DOF_H__ */