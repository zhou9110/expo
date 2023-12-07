#pragma once

#include <shared_mutex>
#include "ABI50_0_0EXGLNativeContext.h"

namespace ABI50_0_0expo {
namespace gl_cpp {

using ContextWithLock = std::pair<ABI50_0_0EXGLContext *, std::shared_lock<std::shared_mutex>>;

ABI50_0_0EXGLContextId ContextCreate();
ContextWithLock ContextGet(ABI50_0_0EXGLContextId id);
void ContextDestroy(ABI50_0_0EXGLContextId id);

} // namespace gl_cpp
} // namespace ABI50_0_0expo
