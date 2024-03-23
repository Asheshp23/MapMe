import SwiftUI
import SwiftfulRouting

struct ContentView: View {
    var body: some View {
      RouterView { router in
        MapMeView()
      }
    }
}

#Preview {
    ContentView()
}
