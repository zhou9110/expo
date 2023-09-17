// Copyright 2023-present 650 Industries. All rights reserved.

import CoreLocation
import ExpoModulesCore

fileprivate let EVENT_LOCATION_CHANGED = "Expo.locationChanged"
fileprivate let EVENT_HEADING_CHANGED = "Expo.headingChanged"

public final class LocationModule: Module {
  private var watchedManagers = [Int: LocationManager]()

  private var taskManager: EXTaskManagerInterface throws {
    guard let taskManager = appContext?.legacyModule(implementing: EXTaskManagerInterface.self) else {
      throw TaskManagerUnavailableException()
    }
    return taskManager
  }

  public func definition() -> ModuleDefinition {
    Name("ExpoLocation")

    Events(EVENT_LOCATION_CHANGED, EVENT_HEADING_CHANGED)

    AsyncFunction("getProviderStatusAsync") {
      return [
        "locationServicesEnabled": CLLocationManager.locationServicesEnabled(),
        "backgroundModeEnabled": true
      ]
    }

    AsyncFunction("getCurrentPositionAsync") { (options: LocationOptions, promise: Promise) in
      try ensureForegroundLocationPermissions(appContext)

      let manager = LocationManager(options: options)

      manager.onUpdateLocations = { (locations: [CLLocation]) in
        if let location = locations.last {
          promise.resolve(EXLocation.export(location))
        } else {
          promise.reject(LocationUnavailableException())
        }
        manager.release()
      }
      manager.onError = { (error: NSError) in
        promise.reject(LocationUnavailableException().causedBy(error))
        manager.release()
      }

      manager.retain().requestLocation()
    }

    AsyncFunction("watchPositionImplAsync") { (watchId: Int, options: LocationOptions, promise: Promise) in
      try ensureForegroundLocationPermissions(appContext)

      let manager = LocationManager(options: options)

      manager.onUpdateLocations = { (locations: [CLLocation]) in
        guard let location = locations.last else {
          promise.reject(LocationUnavailableException())
          return
        }
        self.sendEvent(EVENT_LOCATION_CHANGED, [
          "watchId": watchId,
          "location": EXLocation.export(location)
        ])
      }
      watchedManagers[watchId] = manager.retain()
    }

    AsyncFunction("getLastKnownPositionAsync") { (options: LocationOptions) in
      try ensureForegroundLocationPermissions(appContext)

      let manager = LocationManager(options: options)
      return exportLocation(locationManager.manager.location)
    }

    AsyncFunction("watchDeviceHeading") { (watchId: Int, promise: Promise) in
      try ensureForegroundLocationPermissions(appContext)

      let options = LocationOptions(accuracy: .bestForNavigation, distanceInterval: 0)
      let manager = LocationManager(options: options)

      manager.onUpdateHeading = { (heading: CLHeading) in
        let accuracy = normalizeAccuracy(heading.headingAccuracy)

        self.sendEvent(EVENT_HEADING_CHANGED, [
          "watchId": watchId,
          "heading": [
            "trueHeading": heading.trueHeading,
            "magHeading": heading.magneticHeading,
            "accuracy": accuracy
          ]
        ])
      }
      watchedManagers[watchId] = manager.retain()
    }

    AsyncFunction("removeWatchAsync") { (watchId: Int) in
      if let manager = watchedManagers[watchId] {
        watchedManagers[watchId] = nil
        manager.release()
      }
    }

    AsyncFunction("geocodeAsync") { (address: String. promise: Promise) in
      let geocoder = CLGeocoder()

      geocoder.geocodeAddressString(address) { (placemarks: [CLPlacemark], error: NSError) in
        if let error {
          handleCLError(error: error, promise: promise)
          return
        }

        let results: [[String: Any]] = placemarks.map { placemark in
          return [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "altitude": location.altitude,
            "accuracy": location.horizontalAccuracy,
          ]
        }
        promise.resolve(results)
      }
    }

    AsyncFunction("reverseGeocodeAsync") { (location: CLLocation) in
      let geocoder = CLGeocoder()

      geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark], error: NSError) in
        if let error {
          handleCLError(error: error, promise: promise)
          return
        }

        let results: [[String: Any]] = placemarks.map { placemark in
          return [
            "city": placemark.locality,
            "district": placemark.subLocality,
            "streetNumber": placemark.subThoroughfare,
            "street": placemark.thoroughfare,
            "region": placemark.administrativeArea,
            "subregion": placemark.subAdministrativeArea,
            "country": placemark.country,
            "postalCode": placemark.postalCode,
            "name": placemark.name,
            "isoCountryCode": placemark.isoCountryCode,
            "timezone": placemark.timeZone.name,
          ]
        }
        promise.resolve(results)
      }
    }

    AsyncFunction("getPermissionsAsync") { (promise: Promise) in
      try getPermissionUsingRequester(EXLocationPermissionRequester.self, appContext: appContext, promise: promise)
    }

    AsyncFunction("requestPermissionsAsync") { (promise: Promise) in
      try askForPermissionUsingRequester(EXLocationPermissionRequester.self, appContext: appContext, promise: promise)
    }

    AsyncFunction("getForegroundPermissionsAsync") { (promise: Promise) in
      try getPermissionUsingRequester(EXForegroundPermissionRequester.self, appContext: appContext, promise: promise)
    }

    AsyncFunction("requestForegroundPermissionsAsync") { (promise: Promise) in
      try askForPermissionUsingRequester(EXForegroundPermissionRequester.self, appContext: appContext, promise: promise)
    }

    AsyncFunction("getBackgroundPermissionsAsync") { (promise: Promise) in
      try getPermissionUsingRequester(EXBackgroundLocationPermissionRequester.self, appContext: appContext, promise: promise)
    }

    AsyncFunction("requestBackgroundPermissionsAsync") { (promise: Promise) in
      try askForPermissionUsingRequester(EXBackgroundLocationPermissionRequester.self, appContext: appContext, promise: promise)
    }

    AsyncFunction("hasServicesEnabledAsync") {
      return CLLocationManager.locationServicesEnabled()
    }

    // Background location

    AsyncFunction("startLocationUpdatesAsync") { (taskName: String, options: [String: Any]) in
      try ensureLocationServicesEnabled()
      try ensureForegroundLocationPermissions(appContext)
      try ensureBackgroundLocationPermissions(appContext)
      guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
        throw LocationUpdatesUnavailableException()
      }

      try taskManager.registerTask(withName: taskName, consumer: EXLocationTaskConsumer.self, options: options)
    }

    AsyncFunction("stopLocationUpdatesAsync") { (taskName: String) in
      try taskManager.unregisterTask(withName: taskName, consumerClass: EXLocationTaskConsumer.self)
    }

    AsyncFunction("hasStartedLocationUpdatesAsync") { (taskName: String) -> Bool in
      return try taskManager.task(withName: taskName, hasConsumerOf: EXLocationTaskConsumer.self) ?? false
    }

    // Geofencing

    AsyncFunction("startGeofencingAsync") { (taskName: String, options: [String: Any]) in
      try ensureBackgroundLocationPermissions(appContext)
      guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
        throw GeofencingUnavailableException()
      }

      try taskManager.registerTask(withName: taskName, consumer: EXGeofencingTaskConsumer.self, options: options)
    }

    AsyncFunction("stopGeofencingAsync") { (taskName: String) in
      try taskManager.unregisterTask(withName: taskName, consumerClass: EXGeofencingTaskConsumer.self)
    }

    AsyncFunction("hasStartedGeofencingAsync") { (taskName: String) -> Bool in
      return try taskManager.task(withName: taskName, hasConsumerOf: EXGeofencingTaskConsumer.self) ?? false
    }
  }
}
