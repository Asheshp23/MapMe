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
          .frame(maxWidth: 50, maxHeight: 50)
      }
    }
    .mapStyle(.imagery)
  }
}

#Preview {
  MapMeView()
}
