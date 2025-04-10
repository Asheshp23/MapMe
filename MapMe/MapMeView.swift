import SwiftUI
import MapKit

struct MapMeView: View {
  @State var locationManager = LocationManager()
  @State var cameraHeading: Double = 0.0
  @Namespace var mapScope
  @State var mapCameraPosition = MapCameraPosition.userLocation(followsHeading: true, fallback: .automatic)
  
  var body: some View {
    Map(position: $mapCameraPosition) {
      Annotation("", coordinate: locationManager.userLocation, anchor: .center) {
        Image(systemName: "location.north.circle")
          .resizable()
          .rotationEffect(.degrees(locationManager.userHeading - cameraHeading))
          .foregroundStyle(.blue)
          .frame(maxWidth: 80, maxHeight: 80)
          .background(
            Circle()
              .fill(.white)
          )
      }
      MapPolyline(coordinates: locationManager.userLocations)
        .stroke(.teal, lineWidth: 2.0)
      
    }
    .mapScope(mapScope)
    .mapControls {
      MapPitchToggle(scope: mapScope)
      MapUserLocationButton(scope: mapScope)
      MapCompass(scope: mapScope)
      MapScaleView(scope: mapScope)
    }
    .mapControlVisibility(.visible)
    .mapStyle(.hybrid(elevation: .realistic))
    .onMapCameraChange { mapCameraUpdateContext in
      Task { @MainActor in
        cameraHeading = mapCameraUpdateContext.camera.heading
      }
    }
  }
}

#Preview {
  MapMeView()
}
