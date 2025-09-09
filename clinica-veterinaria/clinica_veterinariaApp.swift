

import SwiftUI
import SwiftData

@main
struct clinica_veterinariaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        .modelContainer(for: [Mascota.self, Cita.self])
    }
}

