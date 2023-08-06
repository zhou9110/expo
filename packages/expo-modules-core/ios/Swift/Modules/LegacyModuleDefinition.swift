// Copyright 2023-present 650 Industries. All rights reserved.

public final class LegacyModuleDefinition: ObjectDefinition {
  let legacyModule: EXExportedModule

  init<LegacyModule: EXExportedModule>(legacyModuleType: LegacyModule.Type) {
    self.legacyModule = LegacyModule()

    super.init(definitions: definitions(fromLegacyModule: legacyModule))
  }
}

internal func definitions(fromLegacyModule module: EXExportedModule) -> [AnyDefinition] {
  var definitions: [AnyDefinition] = []

  definitions.append(OnCreate {
    // TODO: Set module registry
  })

  definitions.append(
    Constants {
      return module.constantsToExport() as? [String: Any?] ?? [:]
    }
  )

  if let eventEmitter = module as? EXEventEmitter {
    let eventEmitterDefinitions: [AnyDefinition] = [
      Events(eventEmitter.supportedEvents()),
      OnStartObserving {
        eventEmitter.startObserving()
      },
      OnStopObserving {
        eventEmitter.stopObserving()
      }
    ]
    definitions.append(contentsOf: eventEmitterDefinitions)
  }

  for methodName in module.getExportedMethods().keys {
    definitions.append(
      AsyncFunction(methodName) { (promise: Promise) in
        // TODO: Support arguments
        module.callExportedMethod(methodName, withArguments: [], resolver: promise.resolver, rejecter: promise.legacyRejecter)
      }
    )
  }
  return definitions
}

public func LegacyModule<LegacyModule: EXExportedModule>(_ legacyModuleType: LegacyModule.Type) -> LegacyModuleDefinition {
  return LegacyModuleDefinition(legacyModuleType: LegacyModule.self)
}
