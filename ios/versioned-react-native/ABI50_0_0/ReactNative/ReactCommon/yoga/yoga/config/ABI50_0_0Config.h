/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <bitset>

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0Errata.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0ExperimentalFeature.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0LogLevel.h>

// Tag struct used to form the opaque ABI50_0_0YGConfigRef for the public C API
struct ABI50_0_0YGConfig {};

namespace ABI50_0_0facebook::yoga {

class Config;
class Node;

using ExperimentalFeatureSet = std::bitset<ordinalCount<ExperimentalFeature>()>;

// Whether moving a node from an old to new config should dirty previously
// calculated layout results.
bool configUpdateInvalidatesLayout(
    const Config& oldConfig,
    const Config& newConfig);

class ABI50_0_0YG_EXPORT Config : public ::ABI50_0_0YGConfig {
 public:
  Config(ABI50_0_0YGLogger logger);

  void setUseWebDefaults(bool useWebDefaults);
  bool useWebDefaults() const;

  void setShouldPrintTree(bool printTree);
  bool shouldPrintTree() const;

  void setExperimentalFeatureEnabled(ExperimentalFeature feature, bool enabled);
  bool isExperimentalFeatureEnabled(ExperimentalFeature feature) const;
  ExperimentalFeatureSet getEnabledExperiments() const;

  void setErrata(Errata errata);
  void addErrata(Errata errata);
  void removeErrata(Errata errata);
  Errata getErrata() const;
  bool hasErrata(Errata errata) const;

  void setPointScaleFactor(float pointScaleFactor);
  float getPointScaleFactor() const;

  void setContext(void* context);
  void* getContext() const;

  void setLogger(ABI50_0_0YGLogger logger);
  void log(
      const yoga::Node* node,
      LogLevel logLevel,
      const char* format,
      va_list args) const;

  void setCloneNodeCallback(ABI50_0_0YGCloneNodeFunc cloneNode);
  ABI50_0_0YGNodeRef
  cloneNode(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGNodeConstRef owner, size_t childIndex) const;

  static const Config& getDefault();

 private:
  ABI50_0_0YGCloneNodeFunc cloneNodeCallback_;
  ABI50_0_0YGLogger logger_;

  bool useWebDefaults_ : 1 = false;
  bool printTree_ : 1 = false;

  ExperimentalFeatureSet experimentalFeatures_{};
  Errata errata_ = Errata::None;
  float pointScaleFactor_ = 1.0f;
  void* context_ = nullptr;
};

inline Config* resolveRef(const ABI50_0_0YGConfigRef ref) {
  return static_cast<Config*>(ref);
}

inline const Config* resolveRef(const ABI50_0_0YGConfigConstRef ref) {
  return static_cast<const Config*>(ref);
}

} // namespace ABI50_0_0facebook::yoga
