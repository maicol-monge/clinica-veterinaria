import SwiftUI
import SwiftData

@main
struct clinica_veterinariaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Owner.self, Mascota.self, Cita.self])
    }
}
