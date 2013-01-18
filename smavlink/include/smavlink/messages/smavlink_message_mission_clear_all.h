#ifndef __SMAVLINK_MESSAGE_MISSION_CLEAR_ALL_H__
#define __SMAVLINK_MESSAGE_MISSION_CLEAR_ALL_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct mission_clear_all_msg {
    uint8_t target_system;
    uint8_t target_component;
};
void smavlink_send_mission_clear_all(struct mission_clear_all_msg* var0,
                                     struct smavlink_out_channel* var1,
                                     struct smavlink_system* var2);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_MISSION_CLEAR_ALL_H__ */