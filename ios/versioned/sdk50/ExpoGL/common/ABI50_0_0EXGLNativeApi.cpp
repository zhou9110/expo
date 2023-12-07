#include "ABI50_0_0EXGLNativeApi.h"
#include "ABI50_0_0EXGLContextManager.h"
#include "ABI50_0_0EXGLNativeContext.h"

using namespace ABI50_0_0expo::gl_cpp;

ABI50_0_0EXGLContextId ABI50_0_0EXGLContextCreate() {
  return ContextCreate();
}

void ABI50_0_0EXGLContextPrepare(
    void *jsiPtr,
    ABI50_0_0EXGLContextId exglCtxId,
    std::function<void(void)> flushMethod) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    exglCtx->prepareContext(*reinterpret_cast<jsi::Runtime *>(jsiPtr), flushMethod);
  }
}

void ABI50_0_0EXGLContextPrepareWorklet(ABI50_0_0EXGLContextId exglCtxId) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    exglCtx->prepareWorkletContext();
  }
}

bool ABI50_0_0EXGLContextNeedsRedraw(ABI50_0_0EXGLContextId exglCtxId) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    return exglCtx->needsRedraw;
  }
  return false;
}

void ABI50_0_0EXGLContextDrawEnded(ABI50_0_0EXGLContextId exglCtxId) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    exglCtx->needsRedraw = false;
  }
}

void ABI50_0_0EXGLContextDestroy(ABI50_0_0EXGLContextId exglCtxId) {
  ContextDestroy(exglCtxId);
}

void ABI50_0_0EXGLContextFlush(ABI50_0_0EXGLContextId exglCtxId) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    exglCtx->flush();
  }
}

void ABI50_0_0EXGLContextSetDefaultFramebuffer(ABI50_0_0EXGLContextId exglCtxId, GLint framebuffer) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    exglCtx->defaultFramebuffer = framebuffer;
  }
}

ABI50_0_0EXGLObjectId ABI50_0_0EXGLContextCreateObject(ABI50_0_0EXGLContextId exglCtxId) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    return exglCtx->createObject();
  }
  return 0;
}

void ABI50_0_0EXGLContextDestroyObject(ABI50_0_0EXGLContextId exglCtxId, ABI50_0_0EXGLObjectId exglObjId) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    exglCtx->destroyObject(exglObjId);
  }
}

void ABI50_0_0EXGLContextMapObject(ABI50_0_0EXGLContextId exglCtxId, ABI50_0_0EXGLObjectId exglObjId, GLuint glObj) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    exglCtx->mapObject(exglObjId, glObj);
  }
}

GLuint ABI50_0_0EXGLContextGetObject(ABI50_0_0EXGLContextId exglCtxId, ABI50_0_0EXGLObjectId exglObjId) {
  auto [exglCtx, lock] = ContextGet(exglCtxId);
  if (exglCtx) {
    return exglCtx->lookupObject(exglObjId);
  }
  return 0;
}
