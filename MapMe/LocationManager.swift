import SwiftUI
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
  @ObservationIgnored let manager = CLLocationManager()
  var userHeading: CLLocationDirection = 0.0
  var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var userLocations: [CLLocationCoordinate2D] = []
  
  override init() {
    super.init()
    manager.delegate = self
    startLocationServices()
  }
  
  deinit {
    manager.stopUpdatingLocation()
    manager.stopUpdatingHeading()
  }
  
  func headingOrientation() -> CLDeviceOrientation {
    let deviceOrientation = UIDevice.current.orientation
   
    switch deviceOrientation {
    case .portrait:
      return .portrait
    case .portraitUpsideDown:
      return .portraitUpsideDown
    case .landscapeLeft:
      return .landscapeRight // Note the flipped mapping
    case .landscapeRight:
      return .landscapeLeft // Note the flipped mapping
    case .faceUp, .faceDown, .unknown:
      fallthrough
    default:
      return .unknown
    }
  }
  
  func startLocationServices() {
    if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
      Task {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.headingOrientation = headingOrientation()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
      }
    } else {
      manager.requestAlwaysAuthorization()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      Task { @MainActor in
        self.userLocation = location.coordinate
        self.userLocations.append(location.coordinate)
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    if newHeading.headingAccuracy < 0 { return }
    
    let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
    Task { @MainActor in
      userHeading = heading
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      startLocationServices()
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    case .denied:
      print("access denied")
    default:
      startLocationServices()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
}
