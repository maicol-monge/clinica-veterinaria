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
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(mascotasFiltradas) { mascota in
                    NavigationLink {
                        MascotaDetailView(mascota: mascota)
                    } label: {
                        HStack {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.Brand.primary)
                                .padding(.trailing, 8)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(mascota.nombre)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(.primary)

                                Text("\(mascota.especie.rawValue) • \(mascota.raza)")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
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
