//  Copyright © 2019 650 Industries. All rights reserved.

// Member variable names here are kept to ease transition to swift. Can rename at end.
// swiftlint:disable identifier_name

import Foundation

@objc(ABI50_0_0EXUpdatesCheckAutomaticallyConfig)
public enum CheckAutomaticallyConfig: Int {
  case Always = 0
  case WifiOnly = 1
  case Never = 2
  case ErrorRecoveryOnly = 3
  public var asString: String {
    switch self {
    case .Always:
      return "ALWAYS"
    case .WifiOnly:
      return "WIFI_ONLY"
    case .Never:
      return "NEVER"
    case .ErrorRecoveryOnly:
      return "ERROR_RECOVERY_ONLY"
    }
  }
}

@objc(ABI50_0_0EXUpdatesConfigError)
public enum UpdatesConfigError: Int, Error {
  case ExpoUpdatesConfigPlistError
  case ExpoUpdatesConfigMissingURLError
  case ExpoUpdatesMissingRuntimeVersionError
}

/**
 * Holds global, immutable configuration values for updates, as well as doing some rudimentary
 * validation.
 *
 * In most apps, these configuration values are baked into the build, and this class functions as a
 * utility for reading and memoizing the values.
 *
 * In development clients (including Expo Go) where this configuration is intended to be dynamic at
 * runtime and updates from multiple scopes can potentially be opened, multiple instances of this
 * class may be created over the lifetime of the app, but only one should be active at a time.
 */
@objc(ABI50_0_0EXUpdatesConfig)
@objcMembers
public final class UpdatesConfig: NSObject {
  public static let PlistName = "Expo"

  public static let ABI50_0_0EXUpdatesConfigEnableAutoSetupKey = "ABI50_0_0EXUpdatesAutoSetup"
  public static let ABI50_0_0EXUpdatesConfigEnabledKey = "ABI50_0_0EXUpdatesEnabled"
  public static let ABI50_0_0EXUpdatesConfigScopeKeyKey = "ABI50_0_0EXUpdatesScopeKey"
  public static let ABI50_0_0EXUpdatesConfigUpdateUrlKey = "ABI50_0_0EXUpdatesURL"
  public static let ABI50_0_0EXUpdatesConfigRequestHeadersKey = "ABI50_0_0EXUpdatesRequestHeaders"
  public static let ABI50_0_0EXUpdatesConfigReleaseChannelKey = "ABI50_0_0EXUpdatesReleaseChannel"
  public static let ABI50_0_0EXUpdatesConfigLaunchWaitMsKey = "ABI50_0_0EXUpdatesLaunchWaitMs"
  public static let ABI50_0_0EXUpdatesConfigCheckOnLaunchKey = "ABI50_0_0EXUpdatesCheckOnLaunch"
  public static let ABI50_0_0EXUpdatesConfigSDKVersionKey = "ABI50_0_0EXUpdatesSDKVersion"
  public static let ABI50_0_0EXUpdatesConfigRuntimeVersionKey = "ABI50_0_0EXUpdatesRuntimeVersion"
  public static let ABI50_0_0EXUpdatesConfigHasEmbeddedUpdateKey = "ABI50_0_0EXUpdatesHasEmbeddedUpdate"
  public static let ABI50_0_0EXUpdatesConfigExpectsSignedManifestKey = "ABI50_0_0EXUpdatesExpectsSignedManifest"
  public static let ABI50_0_0EXUpdatesConfigCodeSigningCertificateKey = "ABI50_0_0EXUpdatesCodeSigningCertificate"
  public static let ABI50_0_0EXUpdatesConfigCodeSigningMetadataKey = "ABI50_0_0EXUpdatesCodeSigningMetadata"
  public static let ABI50_0_0EXUpdatesConfigCodeSigningIncludeManifestResponseCertificateChainKey = "ABI50_0_0EXUpdatesCodeSigningIncludeManifestResponseCertificateChain"
  public static let ABI50_0_0EXUpdatesConfigCodeSigningAllowUnsignedManifestsKey = "ABI50_0_0EXUpdatesConfigCodeSigningAllowUnsignedManifests"
  public static let ABI50_0_0EXUpdatesConfigEnableExpoUpdatesProtocolV0CompatibilityModeKey = "ABI50_0_0EXUpdatesConfigEnableExpoUpdatesProtocolV0CompatibilityMode"

  public static let ABI50_0_0EXUpdatesConfigCheckOnLaunchValueAlways = "ALWAYS"
  public static let ABI50_0_0EXUpdatesConfigCheckOnLaunchValueWifiOnly = "WIFI_ONLY"
  public static let ABI50_0_0EXUpdatesConfigCheckOnLaunchValueErrorRecoveryOnly = "ERROR_RECOVERY_ONLY"
  public static let ABI50_0_0EXUpdatesConfigCheckOnLaunchValueNever = "NEVER"

  public static let ReleaseChannelDefaultValue = "default"

  public let expectsSignedManifest: Bool
  public let scopeKey: String
  public let updateUrl: URL
  public let requestHeaders: [String: String]
  public let releaseChannel: String
  public let launchWaitMs: Int
  public let checkOnLaunch: CheckAutomaticallyConfig
  public let codeSigningConfiguration: CodeSigningConfiguration?

  // used only in Expo Go to prevent loading rollbacks and other directives, which don't make much sense in the context of Expo Go
  public let enableExpoUpdatesProtocolV0CompatibilityMode: Bool

  public let sdkVersion: String?
  public let runtimeVersionRaw: String?
  public let runtimeVersionRealized: String

  public let hasEmbeddedUpdate: Bool

  internal required init(
    expectsSignedManifest: Bool,
    scopeKey: String,
    updateUrl: URL,
    requestHeaders: [String: String],
    releaseChannel: String,
    launchWaitMs: Int,
    checkOnLaunch: CheckAutomaticallyConfig,
    codeSigningConfiguration: CodeSigningConfiguration?,
    sdkVersion: String?,
    runtimeVersionRaw: String?,
    runtimeVersionRealized: String,
    hasEmbeddedUpdate: Bool,
    enableExpoUpdatesProtocolV0CompatibilityMode: Bool
  ) {
    self.expectsSignedManifest = expectsSignedManifest
    self.scopeKey = scopeKey
    self.updateUrl = updateUrl
    self.requestHeaders = requestHeaders
    self.releaseChannel = releaseChannel
    self.launchWaitMs = launchWaitMs
    self.checkOnLaunch = checkOnLaunch
    self.codeSigningConfiguration = codeSigningConfiguration
    self.sdkVersion = sdkVersion
    self.runtimeVersionRaw = runtimeVersionRaw
    self.runtimeVersionRealized = runtimeVersionRealized
    self.hasEmbeddedUpdate = hasEmbeddedUpdate
    self.enableExpoUpdatesProtocolV0CompatibilityMode = enableExpoUpdatesProtocolV0CompatibilityMode
  }

  private static func configDictionaryWithExpoPlist(mergingOtherDictionary: [String: Any]?) throws -> [String: Any] {
    guard let configPlistPath = Bundle.main.path(forResource: PlistName, ofType: "plist") else {
      throw UpdatesConfigError.ExpoUpdatesConfigPlistError
    }

    // swiftlint:disable:next legacy_objc_type
    guard let configNSDictionary = NSDictionary(contentsOfFile: configPlistPath) as? [String: Any] else {
      throw UpdatesConfigError.ExpoUpdatesConfigPlistError
    }

    var dictionary: [String: Any] = configNSDictionary
    if let mergingOtherDictionary = mergingOtherDictionary {
      dictionary = dictionary.merging(mergingOtherDictionary, uniquingKeysWith: { _, new in new })
    }

    return dictionary
  }

  public static func isMissingRuntimeVersion(mergingOtherDictionary: [String: Any]?) -> Bool {
    guard let dictionary = try? configDictionaryWithExpoPlist(mergingOtherDictionary: mergingOtherDictionary) else {
      return true
    }

    let sdkVersion: String? = dictionary.optionalValue(forKey: ABI50_0_0EXUpdatesConfigSDKVersionKey)
    let runtimeVersion: String? = dictionary.optionalValue(forKey: ABI50_0_0EXUpdatesConfigRuntimeVersionKey)

    return (sdkVersion?.isEmpty ?? true) && (runtimeVersion?.isEmpty ?? true)
  }

  public static func canCreateValidConfiguration(mergingOtherDictionary: [String: Any]?) -> Bool {
    guard let dictionary = try? configDictionaryWithExpoPlist(mergingOtherDictionary: mergingOtherDictionary) else {
      return false
    }

    guard dictionary.optionalValue(forKey: ABI50_0_0EXUpdatesConfigEnabledKey) ?? true else {
      return false
    }

    let updateUrl: URL? = dictionary.optionalValue(forKey: ABI50_0_0EXUpdatesConfigUpdateUrlKey).let { it in
      URL(string: it)
    }
    guard updateUrl != nil else {
      return false
    }

    if isMissingRuntimeVersion(mergingOtherDictionary: mergingOtherDictionary) {
      return false
    }

    return true
  }

  public static func configWithExpoPlist(mergingOtherDictionary: [String: Any]?) throws -> UpdatesConfig {
    let dictionary = try configDictionaryWithExpoPlist(mergingOtherDictionary: mergingOtherDictionary)
    return try UpdatesConfig.config(fromDictionary: dictionary)
  }

  public static func config(fromDictionary config: [String: Any]) throws -> UpdatesConfig {
    let expectsSignedManifest = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigExpectsSignedManifestKey) ?? false
    guard let updateUrl = URL(string: config.requiredValue(forKey: ABI50_0_0EXUpdatesConfigUpdateUrlKey)) else {
      throw UpdatesConfigError.ExpoUpdatesConfigMissingURLError
    }
    let scopeKey = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigScopeKeyKey) ?? UpdatesConfig.normalizedURLOrigin(url: updateUrl)

    let requestHeaders: [String: String] = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigRequestHeadersKey) ?? [:]
    let releaseChannel = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigReleaseChannelKey) ?? ReleaseChannelDefaultValue
    let launchWaitMs = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigLaunchWaitMsKey).let { (it: Any) in
      // The only way I can figure out how to detect numbers is to do a is NSNumber (is any Numeric didn't work).
      // This might be able to change when we switch out the plist decoder above
      // swiftlint:disable:next legacy_objc_type
      if let it = it as? NSNumber {
        return it.intValue
      } else if let it = it as? String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter.number(from: it)?.intValue
      }
      return nil
    } ?? 0

    let checkOnLaunch = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigCheckOnLaunchKey).let { (it: String) in
      switch it {
      case ABI50_0_0EXUpdatesConfigCheckOnLaunchValueNever:
        return CheckAutomaticallyConfig.Never
      case ABI50_0_0EXUpdatesConfigCheckOnLaunchValueErrorRecoveryOnly:
        return CheckAutomaticallyConfig.ErrorRecoveryOnly
      case ABI50_0_0EXUpdatesConfigCheckOnLaunchValueWifiOnly:
        return CheckAutomaticallyConfig.WifiOnly
      case ABI50_0_0EXUpdatesConfigCheckOnLaunchValueAlways:
        return CheckAutomaticallyConfig.Always
      default:
        return CheckAutomaticallyConfig.Always
      }
    } ?? CheckAutomaticallyConfig.Always

    let sdkVersion: String? = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigSDKVersionKey)
    let runtimeVersionRaw: String? = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigRuntimeVersionKey)

    guard let runtimeVersionRealized = runtimeVersionRaw ?? sdkVersion else {
      throw UpdatesConfigError.ExpoUpdatesMissingRuntimeVersionError
    }

    let hasEmbeddedUpdate = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigHasEmbeddedUpdateKey) ?? true

    let codeSigningConfiguration = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigCodeSigningCertificateKey).let { (certificateString: String) in
      let codeSigningMetadata: [String: String] = config.requiredValue(forKey: ABI50_0_0EXUpdatesConfigCodeSigningMetadataKey)
      let codeSigningIncludeManifestResponseCertificateChain: Bool = config.optionalValue(
        forKey: ABI50_0_0EXUpdatesConfigCodeSigningIncludeManifestResponseCertificateChainKey
      ) ?? false
      let codeSigningAllowUnsignedManifests: Bool = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigCodeSigningAllowUnsignedManifestsKey) ?? false

      return (try? UpdatesConfig.codeSigningConfigurationForCodeSigningCertificate(
        certificateString,
        codeSigningMetadata: codeSigningMetadata,
        codeSigningIncludeManifestResponseCertificateChain: codeSigningIncludeManifestResponseCertificateChain,
        codeSigningAllowUnsignedManifests: codeSigningAllowUnsignedManifests
      )).require("Invalid code signing configuration")
    }

    let enableExpoUpdatesProtocolV0CompatibilityMode = config.optionalValue(forKey: ABI50_0_0EXUpdatesConfigEnableExpoUpdatesProtocolV0CompatibilityModeKey) ?? false

    return UpdatesConfig(
      expectsSignedManifest: expectsSignedManifest,
      scopeKey: scopeKey,
      updateUrl: updateUrl,
      requestHeaders: requestHeaders,
      releaseChannel: releaseChannel,
      launchWaitMs: launchWaitMs,
      checkOnLaunch: checkOnLaunch,
      codeSigningConfiguration: codeSigningConfiguration,
      sdkVersion: sdkVersion,
      runtimeVersionRaw: runtimeVersionRaw,
      runtimeVersionRealized: runtimeVersionRealized,
      hasEmbeddedUpdate: hasEmbeddedUpdate,
      enableExpoUpdatesProtocolV0CompatibilityMode: enableExpoUpdatesProtocolV0CompatibilityMode
    )
  }

  private static func codeSigningConfigurationForCodeSigningCertificate(
    _ codeSigningCertificate: String,
    codeSigningMetadata: [String: String],
    codeSigningIncludeManifestResponseCertificateChain: Bool,
    codeSigningAllowUnsignedManifests: Bool
  ) throws -> CodeSigningConfiguration? {
    return try CodeSigningConfiguration(
      embeddedCertificateString: codeSigningCertificate,
      metadata: codeSigningMetadata,
      includeManifestResponseCertificateChain: codeSigningIncludeManifestResponseCertificateChain,
      allowUnsignedManifests: codeSigningAllowUnsignedManifests
    )
  }

  public static func normalizedURLOrigin(url: URL) -> String {
    let scheme = url.scheme.require("updateUrl must have a valid scheme")
    let host = url.host.require("updateUrl must have a valid host")
    var portOuter: Int? = url.port
    if let port = portOuter,
      Int(port) > -1,
      port == UpdatesConfig.defaultPortForScheme(scheme: scheme) {
      portOuter = nil
    }

    guard let port = portOuter,
      Int(port) > -1 else {
      return "\(scheme)://\(host)"
    }

    return "\(scheme)://\(host):\(Int(port))"
  }

  private static func defaultPortForScheme(scheme: String?) -> Int? {
    switch scheme {
    case "http":
      return 80
    case "ws":
      return 80
    case "https":
      return 443
    case "wss":
      return 443
    case "ftp":
      return 21
    default:
      return nil
    }
  }
}
