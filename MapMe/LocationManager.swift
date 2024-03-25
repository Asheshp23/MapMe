import Foundation
import UIKit
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  
  var userHeading: CLLocationDirection = 0.0
  var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  
  var userLocations: [CLLocationCoordinate2D] = []
  
  override init() {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
   
    super.init()
    updateHeadingOrientation()
    locationManager.delegate = self
  }
  
  func updateHeadingOrientation() {
    let deviceOrientation = UIDevice.current.orientation
    let clDeviceOrientation: CLDeviceOrientation
    
    switch deviceOrientation {
    case .portrait:
      clDeviceOrientation = .portrait
    case .portraitUpsideDown:
      clDeviceOrientation = .portraitUpsideDown
    case .landscapeLeft:
      clDeviceOrientation = .landscapeRight // Note the flipped mapping
    case .landscapeRight:
      clDeviceOrientation = .landscapeLeft // Note the flipped mapping
    case .faceUp, .faceDown, .unknown:
      fallthrough
    default:
      clDeviceOrientation = .unknown // Default or unchanged
    }
    
    locationManager.headingOrientation = clDeviceOrientation
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      self.userLocation = location.coordinate
      self.userLocations.append(location.coordinate)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    if newHeading.headingAccuracy < 0 { return }
    
    let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
    userHeading = heading
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error getting location: \(error)")
  }
}
