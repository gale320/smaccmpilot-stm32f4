/* This file has been autogenerated by Ivory
 * Compiler version  5326f414a5a63af59269d31f823a2e142af0b2c9
 */
#ifndef __SMAVLINK_MESSAGE_SYS_STATUS_H__
#define __SMAVLINK_MESSAGE_SYS_STATUS_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct sys_status_msg {
    uint32_t onboard_control_sensors_present;
    uint32_t onboard_control_sensors_enabled;
    uint32_t onboard_control_sensors_health;
    uint16_t load;
    uint16_t voltage_battery;
    int16_t current_battery;
    uint16_t drop_rate_comm;
    uint16_t errors_comm;
    uint16_t errors_count1;
    uint16_t errors_count2;
    uint16_t errors_count3;
    uint16_t errors_count4;
    int8_t battery_remaining;
};
void smavlink_send_sys_status(struct sys_status_msg* n_var0,
                              struct smavlink_out_channel* n_var1,
                              struct smavlink_system* n_var2);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_SYS_STATUS_H__ */