import SwiftUI
import SwiftData

struct CitaDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var cita: Cita
    
    @State private var notaSeguimiento: String = ""
    
    var body: some View {
        Form {
            Section("Mascota") {
                Text(cita.mascota?.nombre ?? "Sin mascota")
            }
            
            Section("Detalles de la Cita") {
                Text("Fecha: \(cita.fecha.formatted(date: .abbreviated, time: .shortened))")
                Text("Servicio: \(cita.servicio.rawValue)")
            }
            
            Section("Estado") {
                Picker("Estado", selection: $cita.estado) {
                    ForEach(EstadoCita.allCases, id: \.self) { estado in
                        Text(estado.rawValue).tag(estado)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Notas de seguimiento") {
                TextEditor(text: $notaSeguimiento)
                    .frame(minHeight: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }
        }
        .navigationTitle("Detalle Cita")
        .onAppear {
            notaSeguimiento = cita.detalle ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    cita.detalle = notaSeguimiento
                    try? context.save()
                    dismiss()
                }
            }
        }
    }
}
