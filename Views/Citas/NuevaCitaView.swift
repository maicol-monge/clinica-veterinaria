import SwiftUI
import SwiftData

struct NuevaCitaView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var mascotas: [Mascota]
    
    @State private var mascotaSeleccionada: Mascota?
    @State private var fecha = Date()
    @State private var servicio: Servicio = .consulta
    @State private var detalle = ""
    
    var serviciosDisponibles: [Servicio] {
        if mascotaSeleccionada?.especie == .perro {
            return [.consulta, .banoBasico, .banoUñas, .banoEstetico, .banoMedicado, .emergencia]
        } else {
            return [.consulta, .emergencia]
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Mascota", selection: $mascotaSeleccionada) {
                    ForEach(mascotas) { mascota in
                        Text(mascota.nombre).tag(Optional(mascota))
                    }
                }
                
                DatePicker("Fecha y Hora", selection: $fecha)
                
                Picker("Servicio", selection: $servicio) {
                    ForEach(serviciosDisponibles, id: \.self) { servicio in
                        Text(servicio.rawValue).tag(servicio)
                    }
                }
                
                TextField("Detalle (opcional)", text: $detalle)
            }
            .navigationTitle("Nueva Cita")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        guard let mascota = mascotaSeleccionada else { return }
                        let nueva = Cita(
                            fecha: fecha,
                            servicio: servicio,
                            estado: .pendiente,
                            detalle: detalle,
                            mascota: mascota
                        )
                        context.insert(nueva)
                        try? context.save()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
