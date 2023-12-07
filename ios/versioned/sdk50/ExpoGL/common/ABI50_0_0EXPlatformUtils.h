#pragma once

#ifdef __APPLE__

namespace ABI50_0_0expo {
namespace gl_cpp {
void ABI50_0_0EXiOSLog(const char *msg, ...) __attribute__((format(printf, 1, 2)));

typedef struct {
  long majorVersion;
  long minorVersion;
  long patchVersion;
} ABI50_0_0EXiOSOperatingSystemVersion;

ABI50_0_0EXiOSOperatingSystemVersion ABI50_0_0EXiOSGetOperatingSystemVersion(void);
} // namespace gl_cpp
} // namespace ABI50_0_0expo

#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#define ABI50_0_0EXGL_DEBUG // Whether debugging is on

#ifdef ABI50_0_0EXGL_DEBUG
#ifdef __ANDROID__
#define ABI50_0_0EXGLSysLog(fmt, ...) __android_log_print(ANDROID_LOG_ERROR, "ABI50_0_0EXGL", fmt, ##__VA_ARGS__)
#endif
#ifdef __APPLE__
#define ABI50_0_0EXGLSysLog(fmt, ...) ABI50_0_0EXiOSLog("ABI50_0_0EXGL: " fmt, ##__VA_ARGS__)
#endif
#else
#define ABI50_0_0EXGLSysLog(...)
#endif
