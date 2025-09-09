


import SwiftUI
import SwiftData

struct MascotasView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Mascota.nombre) private var mascotas: [Mascota]
    
    @State private var mostrarNuevaMascota = false
    
    var body: some View {
        List {
            ForEach(mascotas) { mascota in
                NavigationLink(mascota.nombre) {
                    MascotaDetailView(mascota: mascota)
                }
            }
            .onDelete { indices in
                for index in indices {
                    context.delete(mascotas[index])
                }
                try? context.save()
            }
        }
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
