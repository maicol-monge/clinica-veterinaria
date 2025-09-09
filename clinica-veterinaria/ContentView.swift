import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("👤 Dueños y Mascotas") {
                    MascotasView()
                }
                NavigationLink("📅 Citas") {
                    CitasView()
                }
            }
            .navigationTitle("Clínica Veterinaria")
        }
    }
}
