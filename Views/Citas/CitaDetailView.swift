import SwiftUI
import SwiftData

struct CitaDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var cita: Cita
    @State private var notaSeguimiento: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // 🐾 Mascota
                if let mascota = cita.mascota {
                    NavigationLink {
                        MascotaDetailView(mascota: mascota)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Label {
                                Text(mascota.nombre)
                                    .font(.title2.bold())
                                    .foregroundStyle(Color.Brand.secondary)
                            } icon: {
                                Image(systemName: iconoEspecie(mascota.especie))
                                    .font(.system(size: 30))
                                    .foregroundStyle(Color.Brand.primary)
                            }
                            
                            Text("\(mascota.especie.rawValue) • \(mascota.raza)")
                                .font(.subheadline)
                                .foregroundStyle(Color.Brand.secondary)
                            
                            if let owner = mascota.owner {
                                Text("Dueño: \(owner.nombre)")
                                    .font(.caption)
                                    .foregroundStyle(Color.Brand.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.Brand.primary.opacity(0.08))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                } else {
                    // Si no hay mascota asociada
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Sin mascota", systemImage: "pawprint.fill")
                            .font(.title2.bold())
                            .foregroundStyle(Color.Brand.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.Brand.primary.opacity(0.08))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                }

                
                // 📅 Detalles
                VStack(alignment: .leading, spacing: 8) {
                    Label("Fecha y Hora", systemImage: "calendar")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    Text(cita.fecha.formatted(date: .abbreviated, time: .shortened))
                        .font(.body)
                        .foregroundStyle(Color.Brand.secondary)
                    
                    Divider()
                    
                    Label("Servicio", systemImage: iconoServicio(cita.servicio))
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    Text(cita.servicio.rawValue)
                        .font(.body)
                        .foregroundStyle(Color.Brand.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.Brand.primary.opacity(0.08))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                
                // 🔄 Estado
                VStack(alignment: .leading, spacing: 12) {
                    Text("Estado")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    Picker("Estado", selection: $cita.estado) {
                        ForEach(EstadoCita.allCases, id: \.self) { estado in
                            Text(estado.rawValue).tag(estado)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.Brand.primary.opacity(0.08))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                
                // 📝 Notas
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notas de seguimiento")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    TextEditor(text: $notaSeguimiento)
                        .frame(minHeight: 120)
                        .padding(8)
                        .background(Color.Brand.primary.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.Brand.primary.opacity(0.08))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
            }
            .padding()
        }
        .background(Color.Brand.background)
        .navigationTitle("Detalle de Cita")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    cita.detalle = notaSeguimiento
                    try? context.save()
                    dismiss()
                }
                .foregroundStyle(Color.Brand.primary)
            }
        }
        .onAppear {
            notaSeguimiento = cita.detalle ?? ""
        }
    }
    
    // MARK: - Helpers
    private func iconoEspecie(_ especie: Especie?) -> String {
        switch especie {
        case .perro: return "dog.fill"
        case .gato: return "cat.fill"
        case .conejo: return "hare.fill"
        default: return "pawprint.fill"
        }
    }
    
    private func iconoServicio(_ servicio: Servicio) -> String {
        switch servicio {
        case .consulta: return "stethoscope"
        case .emergencia: return "cross.case.fill"
        case .banoBasico: return "drop.fill"
        case .banoUñas: return "scissors"
        case .banoEstetico: return "sparkles"
        case .banoMedicado: return "bandage.fill"
        }
    }
}
