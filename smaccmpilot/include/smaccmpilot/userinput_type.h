/* This file has been autogenerated by Ivory
 * Compiler version  b48fa4470fb0630f5faec99220f1a507651451af
 */
#ifndef __USERINPUT_TYPE_H__
#define __USERINPUT_TYPE_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
struct userinput_result {
    bool armed;
    float throttle;
    float roll;
    float pitch;
    float yaw;
    uint32_t time;
};

#ifdef __cplusplus
}
#endif
#endif /* __USERINPUT_TYPE_H__ */