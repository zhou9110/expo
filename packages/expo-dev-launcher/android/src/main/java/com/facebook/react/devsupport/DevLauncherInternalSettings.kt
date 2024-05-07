package com.facebook.react.devsupport

import android.content.Context
import expo.modules.devlauncher.react.DevLauncherPackagerConnectionSettings

internal class DevLauncherInternalSettings(
  context: Context,
  debugServerHost: String
) : DevInternalSettingsBase(context, null) {
  override val packagerConnectionSettings = DevLauncherPackagerConnectionSettings(context, debugServerHost)

  @Suppress("FunctionName")
  fun public_getPackagerConnectionSettings() = packagerConnectionSettings
}
