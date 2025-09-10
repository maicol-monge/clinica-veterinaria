import SwiftUI
import SwiftData

struct CitaDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var cita: Cita   // ✅ Esto permite editar directamente propiedades del modelo
    
    var body: some View {
        Form {
            Section("Mascota") {
                Text(cita.mascota?.nombre ?? "Sin mascota")
            }
            
            Section("Detalles de la Cita") {
                Text("Fecha: \(cita.fecha.formatted(date: .abbreviated, time: .shortened))")
                Text("Servicio: \(cita.servicio.rawValue)")
                if let detalle = cita.detalle, !detalle.isEmpty {
                    Text("Nota: \(detalle)")
                }
            }
            
            Section("Estado") {
                Picker("Estado", selection: $cita.estado) {
                    ForEach(EstadoCita.allCases, id: \.self) { estado in
                        Text(estado.rawValue).tag(estado)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Detalle Cita")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    try? context.save()
                    dismiss()
                }
            }
        }
    }
}
