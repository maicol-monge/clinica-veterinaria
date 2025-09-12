import SwiftUI
import SwiftData

struct CitasView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Cita.fecha) private var citas: [Cita]

    @State private var searchText = ""
    @State private var mostrarNuevaCita = false
    
    // 🔑 Filtros
    @State private var fechaInicio: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var fechaFin: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var estadoSeleccionado: EstadoCita? = nil  // nil = todos
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale.current
        return formatter
    }

    // 🔎 Lógica de filtrado
    var citasFiltradas: [Cita] {
        citas.filter { cita in
            let fechaTexto = dateFormatter.string(from: cita.fecha)
            
            let coincideTexto = searchText.isEmpty ||
                cita.servicio.rawValue.localizedCaseInsensitiveContains(searchText) ||
                cita.mascota?.nombre.localizedCaseInsensitiveContains(searchText) ?? false ||
                cita.mascota?.id.uuidString.localizedCaseInsensitiveContains(searchText) ?? false ||
                fechaTexto.localizedCaseInsensitiveContains(searchText)
            
            let coincideFecha = (cita.fecha >= fechaInicio && cita.fecha <= fechaFin)
            let coincideEstado = estadoSeleccionado == nil || cita.estado == estadoSeleccionado
            
            return coincideTexto && coincideFecha && coincideEstado
        }
    }
    
    // 🔎 Ícono según servicio
    private func iconoParaServicio(_ servicio: Servicio) -> String {
        switch servicio {
        case .consulta: return "stethoscope"
        case .emergencia: return "cross.case.fill"
        case .banoBasico: return "drop"
        case .banoUñas: return "scissors"
        case .banoEstetico: return "sparkles"
        case .banoMedicado: return "bandage.fill"
        }
    }

    var body: some View {
        VStack {
            // 🔎 Filtros
            VStack(spacing: 12) {
                VStack {
                    DatePicker("Desde", selection: $fechaInicio, displayedComponents: .date)
                    DatePicker("Hasta", selection: $fechaFin, displayedComponents: .date)
                }
                Picker("Estado", selection: $estadoSeleccionado) {
                    Text("Todos").tag(EstadoCita?.none)
                    ForEach(EstadoCita.allCases, id: \.self) { estado in
                        Text(estado.rawValue.capitalized).tag(Optional(estado))
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(Color.Brand.primary.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal)

            // 🔎 Lista de citas
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(citasFiltradas) { cita in
                        NavigationLink {
                            CitaDetailView(cita: cita)
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: iconoParaServicio(cita.servicio))
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.Brand.primary)
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(cita.servicio.rawValue)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color.Brand.primary)
                                    
                                    Text(cita.fecha, style: .date)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.Brand.secondary)
                                    
                                    if let mascota = cita.mascota {
                                        Text("Mascota: \(mascota.nombre)")
                                            .font(.caption)
                                            .foregroundStyle(Color.Brand.secondary)
                                    }
                                    
                                    Text(cita.estado.rawValue)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.Brand.primary.opacity(0.1))
                                        .cornerRadius(6)
                                        .foregroundStyle(Color.Brand.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.Brand.primary.opacity(0.08))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.Brand.background.ignoresSafeArea())
        .searchable(text: $searchText, prompt: "Buscar citas...")
        .navigationTitle("Citas")
        .toolbar {
            Button(action: { mostrarNuevaCita = true }) {
                Label("Nueva Cita", systemImage: "plus")
                    .foregroundStyle(Color.Brand.primary)
            }
        }
        .sheet(isPresented: $mostrarNuevaCita) {
            NuevaCitaView()
        }
    }
}
