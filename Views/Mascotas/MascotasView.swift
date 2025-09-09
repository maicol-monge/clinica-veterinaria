import SwiftUI
import SwiftData

struct MascotasView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Mascota.nombre) private var mascotas: [Mascota]
    
    @State private var searchText = ""
    @State private var mostrarNuevaMascota = false
    
    var mascotasFiltradas: [Mascota] {
        mascotas.filter { mascota in
            searchText.isEmpty ||
            mascota.nombre.localizedCaseInsensitiveContains(searchText) ||
            mascota.especie.rawValue.localizedCaseInsensitiveContains(searchText) ||
            mascota.raza.localizedCaseInsensitiveContains(searchText) ||
            (mascota.owner?.nombre.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (mascota.owner?.telefono.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var body: some View {
        List {
            ForEach(mascotasFiltradas) { mascota in
                NavigationLink(mascota.nombre) {
                    MascotaDetailView(mascota: mascota)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Buscar mascotas...")
        .navigationTitle("Mascotas")
        .toolbar {
            Button(action: { mostrarNuevaMascota = true }) {
                Label("Agregar", systemImage: "plus")
            }
        }
        .sheet(isPresented: $mostrarNuevaMascota) {
            NuevaMascotaView()
        }
    }
}
