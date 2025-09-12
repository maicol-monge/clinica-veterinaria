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
            mascota.id.uuidString.localizedCaseInsensitiveContains(searchText) ||
            (mascota.owner?.nombre.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (mascota.owner?.telefono.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    private func iconoParaEspecie(_ especie: Especie) -> String {
        switch especie {
        case .perro: return "pawprint.fill"
        case .gato: return "cat.fill"
        case .conejo: return "hare.fill"
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(mascotasFiltradas) { mascota in
                    NavigationLink {
                        MascotaDetailView(mascota: mascota)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: iconoParaEspecie(mascota.especie))
                                .font(.system(size: 28))
                                .foregroundStyle(Color.Brand.primary)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(mascota.nombre)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.Brand.secondary)

                                Text("\(mascota.especie.rawValue) • \(mascota.raza)")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(Color.Brand.secondary)

                                if let owner = mascota.owner {
                                    Text("Dueño: \(owner.nombre)")
                                        .font(.caption)
                                        .foregroundStyle(Color.Brand.secondary)
                                }
                            }

                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.Brand.primary.opacity(0.08))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                }
            }
            .padding()
        }
        .background(Color.Brand.background.ignoresSafeArea())
        .searchable(text: $searchText, prompt: "Buscar mascotas...")
        .navigationTitle("Mascotas")
        .toolbar {
            Button(action: { mostrarNuevaMascota = true }) {
                Label("Agregar", systemImage: "plus")
                    .foregroundStyle(Color.Brand.primary)
            }
        }
        .sheet(isPresented: $mostrarNuevaMascota) {
                    NavigationStack {
                        NuevaMascotaView()
                    }
                }
    }
}
