import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("📋 Expedientes de Mascotas") {
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
#Preview {
    ContentView()
}
