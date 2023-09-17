// Copyright 2023-present 650 Industries. All rights reserved.

import ExpoModulesCore

extension CLLocation: Convertible {
  static func convert(from value: Any?, appContext: AppContext) throws -> Self {
    if let value = value as? [String: Any] {
      let args = try Conversions.pickValues(from: value, byKeys: ["latitude", "longitude"], as: String.self)
      return CLLocation(latitude: args[0], longitude: args[1])
    }
    throw Conversions.ConvertingException<CLLocation>(value)
  }
}
