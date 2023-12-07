// Copyright 2022-present 650 Industries. All rights reserved.

#ifdef __cplusplus

#import <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace jsi = ABI50_0_0facebook::jsi;

namespace ABI50_0_0expo::common {

class JSI_EXPORT ObjectDeallocator : public jsi::HostObject {
public:
  typedef std::function<void()> Block;

  ObjectDeallocator(const Block deallocator) : deallocator(deallocator) {};

  virtual ~ObjectDeallocator() {
    deallocator();
  }

  const Block deallocator;

}; // class ObjectDeallocator

/**
 Sets the deallocator block on a given object, which is called when the object is being deallocated.
 */
void setDeallocator(
  jsi::Runtime &runtime,
  const std::shared_ptr<jsi::Object> &jsThis,
  ObjectDeallocator::Block deallocatorBlock,
  const std::string &key = "__expo_object_deallocator__"
);

} // namespace ABI50_0_0expo::common

#endif
