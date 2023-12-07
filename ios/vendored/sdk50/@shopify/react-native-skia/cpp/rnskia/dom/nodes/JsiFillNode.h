#pragma once

#include "JsiDomDrawingNode.h"
#include "RectProp.h"

#include <memory>

namespace ABI50_0_0RNSkia {

class JsiFillNode : public JsiDomDrawingNode,
                    public JsiDomNodeCtor<JsiFillNode> {
public:
  explicit JsiFillNode(std::shared_ptr<ABI50_0_0RNSkPlatformContext> context)
      : JsiDomDrawingNode(context, "skFill") {}

protected:
  void draw(DrawingContext *context) override {
    context->getCanvas()->drawPaint(*context->getPaint());
  }
};

} // namespace ABI50_0_0RNSkia
