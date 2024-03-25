import SwiftUI
import MapKit

struct MapMeView: View {
  @State var locationManager = LocationManager()

  var body: some View {
    Map() {
      Annotation("", coordinate: locationManager.userLocation) {
        Image(systemName: "location.north.circle")
          .resizable()
          .rotationEffect(.degrees(locationManager.userHeading))
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
    .mapStyle(.imagery)
  }
}

#Preview {
  MapMeView()
}
