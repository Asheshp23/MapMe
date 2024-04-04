import SwiftUI
import MapKit

struct MapMeView: View {
  @State var locationManager = LocationManager()
  @State var cameraHeading: Double = 0.0

  var body: some View {
    Map(interactionModes: [.pan, .zoom, .rotate]) {
      Annotation("", coordinate: locationManager.userLocation) {
        Image(systemName: "location.north.circle")
          .resizable()
          .rotationEffect(.degrees( locationManager.userHeading - cameraHeading))
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
