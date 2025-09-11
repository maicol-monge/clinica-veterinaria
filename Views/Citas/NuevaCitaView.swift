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
    @State private var searchText = ""
    
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    
    private func serviciosDisponibles() -> [Servicio] {
        if mascotaSeleccionada?.especie == .perro {
            return [.consulta, .banoBasico, .banoUñas, .banoEstetico, .banoMedicado, .emergencia]
        } else {
            return [.consulta, .emergencia]
        }
    }
    
    var mascotasFiltradas: [Mascota] {
        mascotas.filter { mascota in
            searchText.isEmpty ||
            mascota.nombre.localizedCaseInsensitiveContains(searchText) ||
            mascota.raza.localizedCaseInsensitiveContains(searchText) ||
            mascota.id.uuidString.localizedCaseInsensitiveContains(searchText) ||   // ← BUSCAR POR ID
            (mascota.owner?.nombre.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (mascota.owner?.telefono.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    
    var body: some View {
        NavigationStack {
            Form {
                Section("Mascota") {
                    TextField("Buscar mascota...", text: $searchText)
                    List(mascotasFiltradas) { mascota in
                        Button {
                            mascotaSeleccionada = mascota
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(mascota.nombre)
                                        .font(.headline)
                                    Text("\(mascota.especie.rawValue) • \(mascota.raza)")
                                        .font(.caption)
                                    if let owner = mascota.owner {
                                        Text("Dueño: \(owner.nombre)")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                if mascotaSeleccionada == mascota {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .frame(minHeight: 100, maxHeight: 200)
                }
                
                Section("Fecha y Hora") {
                    DatePicker("Seleccionar", selection: $fecha)
                }
                
                
                
                Section("Detalle (opcional)") {
                    TextField("Agregar notas...", text: $detalle)
                }
            }
            .navigationTitle("Nueva Cita")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        if validarCampos() {
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
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .alert("Error", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(mensajeAlerta)
            }
        }
    }
    
    private func validarCampos() -> Bool {
        if mascotaSeleccionada == nil {
            mensajeAlerta = "Debes seleccionar una mascota."
            mostrarAlerta = true
            return false
        }
        if fecha < Date() {
            mensajeAlerta = "La fecha de la cita no puede ser en el pasado."
            mostrarAlerta = true
            return false
        }
        return true
    }
}
