
#ifndef __SMACCMPILOT_GCS_TRANSMIT_H__
#define __SMACCMPILOT_GCS_TRANSMIT_H__

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>

#include "flight-generated/motorsoutput_type.h"
#include "flight-generated/position_type.h"
#include "flight-generated/sensors_type.h"
#include "flight-generated/servo_type.h"
#include "flight-generated/userinput_type.h"

#define GCS_TRANSMIT_STREAM_HEARTBEAT        1
#define GCS_TRANSMIT_STREAM_SERVO_OUTPUT_RAW 2
#define GCS_TRANSMIT_STREAM_ATTITUDE         3
#define GCS_TRANSMIT_STREAM_GPS_RAW_INT      4
#define GCS_TRANSMIT_STREAM_VFR_HUD          5
#define GCS_TRANSMIT_STREAM_GLOBAL_POSITION_INT 6
#define GCS_TRANSMIT_STREAM_PARAMS           7
#define GCS_TRANSMIT_NUM_STREAMS             8

void gcs_transmit_init(void);
void gcs_transmit_start_task(void);

void gcs_transmit_set_states( const struct sensors_result *sensors,
                              const struct position_result *position,
                              const struct motorsoutput_result *motors,
                              const struct servo_result *servo,
                              const struct userinput_result *user);

void gcs_transmit_set_stream_rate(int stream, bool enable, uint16_t rate_hz );

#ifdef __cplusplus
}
#endif

#endif // __SMACCMPILOT_GCS_TRANSMIT_H__
