#pragma once

#include <algorithm>

namespace ABI50_0_0reanimated {
namespace collection {

template <class CollectionType, class ValueType>
inline bool contains(const CollectionType &collection, const ValueType &value) {
  return collection.find(value) != collection.end();
}

} // namespace collection
} // namespace reanimated
