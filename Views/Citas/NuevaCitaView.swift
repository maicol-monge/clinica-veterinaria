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
    
    // MARK: - Servicios según especie
    private func serviciosDisponibles() -> [Servicio] {
        if mascotaSeleccionada?.especie == .perro {
            return [.consulta, .banoBasico, .banoUñas, .banoEstetico, .banoMedicado, .emergencia]
        } else {
            return [.consulta, .emergencia]
        }
    }
    
    // MARK: - Mascotas filtradas
    var mascotasFiltradas: [Mascota] {
        mascotas.filter { mascota in
            searchText.isEmpty ||
            mascota.nombre.localizedCaseInsensitiveContains(searchText) ||
            mascota.raza.localizedCaseInsensitiveContains(searchText) ||
            mascota.id.uuidString.localizedCaseInsensitiveContains(searchText) ||
            (mascota.owner?.nombre.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (mascota.owner?.telefono.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🔎 Buscar mascota
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mascota")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    TextField("Buscar mascota...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if mascotasFiltradas.isEmpty {
                        Text("No se encontraron mascotas")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(mascotasFiltradas) { mascota in
                            Button {
                                mascotaSeleccionada = mascota
                            } label: {
                                HStack {
                                    Image(systemName: iconoEspecie(mascota.especie))
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color.Brand.primary)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading) {
                                        Text(mascota.nombre)
                                            .font(.subheadline).bold()
                                            .foregroundStyle(Color.Brand.secondary)
                                        Text("\(mascota.especie.rawValue) • \(mascota.raza)")
                                            .font(.caption)
                                            .foregroundStyle(Color.Brand.secondary)
                                        if let owner = mascota.owner {
                                            Text("Dueño: \(owner.nombre)")
                                                .font(.caption2)
                                                .foregroundStyle(Color.Brand.secondary)
                                        }
                                    }
                                    Spacer()
                                    if mascotaSeleccionada == mascota {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.Brand.primary)
                                    }
                                }
                                .padding(8)
                                .background(Color.Brand.primary.opacity(0.08))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                            }
                        }
                    }
                }
                
                // 📅 Fecha
                VStack(alignment: .leading, spacing: 12) {
                    Text("Fecha y hora")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    DatePicker("Seleccionar", selection: $fecha)
                        .datePickerStyle(.compact)
                }
                
                // 🛠 Servicio
                if mascotaSeleccionada != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Servicio")
                            .font(.headline)
                            .foregroundStyle(Color.Brand.primary)
                        
                        Picker("Servicio", selection: $servicio) {
                            ForEach(serviciosDisponibles(), id: \.self) { s in
                                Text(s.rawValue).tag(s)
                            }
                            .foregroundStyle(Color.Brand.secondary)
                        }
                        .pickerStyle(.menu)
                        
                        Text(descripcionServicio(servicio))
                            .font(.footnote)
                            .foregroundStyle(Color.Brand.secondary)
                    }
                }
                
                // 📝 Detalles
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notas (opcional)")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    TextField("Agregar notas...", text: $detalle, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3, reservesSpace: true)
                }
                
                // ✅ Botón Guardar
                Button {
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
                } label: {
                    Text("Guardar Cita")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.Brand.primary)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .background(Color.Brand.background.ignoresSafeArea())
        .navigationTitle("Nueva Cita")
        .alert("Error", isPresented: $mostrarAlerta) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mensajeAlerta)
        }
    }
    
    // MARK: - Validaciones
    private func validarCampos() -> Bool {
        guard let mascota = mascotaSeleccionada else {
            mensajeAlerta = "Debes seleccionar una mascota."
            mostrarAlerta = true
            return false
        }
        if fecha < Date() {
            mensajeAlerta = "La fecha de la cita no puede ser en el pasado."
            mostrarAlerta = true
            return false
        }
        
        // 🚨 Reglas según servicio
        switch servicio {
        case .emergencia:
            // Emergencias siempre se permiten (excepto pasado, ya validado arriba)
            return true
            
        case .banoBasico, .banoUñas, .banoEstetico, .banoMedicado:
            // Obtener todas las citas de todas las mascotas
            let todasLasCitas = mascotas.flatMap { $0.citas }
            
            // Verificar si ya hay un baño aceptado en la misma fecha y hora
            let existeBano = todasLasCitas.contains { cita in
                cita.fecha == fecha &&
                cita.estado == .aceptada &&
                (
                    cita.servicio == .banoBasico ||
                    cita.servicio == .banoUñas ||
                    cita.servicio == .banoEstetico ||
                    cita.servicio == .banoMedicado
                )
            }
            
            if existeBano {
                mensajeAlerta = "Ya existe un baño aceptado en esa fecha y hora."
                mostrarAlerta = true
                return false
            }
            return true

            
        case .consulta:
            // No se permite si ya existe otra consulta aceptada en la misma fecha y hora
            let existeConsultaAceptada = mascotas
                .flatMap { $0.citas }
                .contains(where: { $0.fecha == fecha && $0.servicio == .consulta && $0.estado == .aceptada })
            
            if existeConsultaAceptada {
                mensajeAlerta = "Ya existe una consulta aceptada en esa fecha y hora."
                mostrarAlerta = true
                return false
            }
            return true
        }
    }


    
    // MARK: - Helpers
    private func descripcionServicio(_ servicio: Servicio) -> String {
        switch servicio {
        case .consulta: return "Consulta médica general para cualquier mascota."
        case .emergencia: return "Atención inmediata en casos críticos."
        case .banoBasico: return "Un lavado y secado simple."
        case .banoUñas: return "Baño básico más recorte de uñas."
        case .banoEstetico: return "Baño con corte de pelo y estilo."
        case .banoMedicado: return "Baño con champú especial para problemas de piel."
        }
    }
    
    private func iconoEspecie(_ especie: Especie) -> String {
        switch especie {
        case .perro: return "dog.fill"
        case .gato: return "cat.fill"
        case .conejo: return "hare.fill"
        }
    }
}
