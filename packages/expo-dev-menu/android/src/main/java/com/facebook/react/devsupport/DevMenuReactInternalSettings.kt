@file:Suppress("RedundantVisibilityModifier")

package com.facebook.react.devsupport

import android.content.Context
import expo.modules.devmenu.react.DevMenuPackagerConnectionSettings

/**
 * Class representing react's internal [DevInternalSettings] class, which we want to replace to change [packagerConnectionSettings] and others settings.
 * It is only use when [expo.modules.devmenu.DevMenuReactNativeHost.getUseDeveloperSupport] returns true.
 */
internal class DevMenuReactInternalSettings(
  serverIp: String,
  application: Context
) : DevInternalSettingsBase(application, null) {
  override val packagerConnectionSettings = DevMenuPackagerConnectionSettings(serverIp, application)

  override var isElementInspectorEnabled = false

  override var isJSMinifyEnabled = false

  override var isJSDevModeEnabled = true

  override var isStartSamplingProfilerOnInit = false

  override var isAnimationFpsDebugEnabled = false

  override var isRemoteJSDebugEnabled = false

  override var isHotModuleReplacementEnabled = true

  override var isFpsDebugEnabled = false
}
