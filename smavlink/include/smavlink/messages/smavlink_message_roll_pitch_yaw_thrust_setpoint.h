/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#ifndef __SMAVLINK_MESSAGE_ROLL_PITCH_YAW_THRUST_SETPOINT_H__
#define __SMAVLINK_MESSAGE_ROLL_PITCH_YAW_THRUST_SETPOINT_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct roll_pitch_yaw_thrust_setpoint_msg {
    uint32_t time_boot_ms;
    float roll;
    float pitch;
    float yaw;
    float thrust;
};
void smavlink_send_roll_pitch_yaw_thrust_setpoint(struct roll_pitch_yaw_thrust_setpoint_msg* n_var0,
                                                  struct smavlink_out_channel* n_var1,
                                                  struct smavlink_system* n_var2);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_ROLL_PITCH_YAW_THRUST_SETPOINT_H__ */