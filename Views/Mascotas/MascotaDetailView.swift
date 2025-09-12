import SwiftUI
import SwiftData

struct MascotaDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var mascota: Mascota
    
    // Estado edición
    @State private var isEditing = false
    
    // Campos editables mascota
    @State private var nombre: String = ""
    @State private var especie: Especie = .perro
    @State private var raza: String = ""
    @State private var fechaNacimiento: Date = Date()
    
    // Campos editables dueño
    @State private var nombreDueno: String = ""
    @State private var telefonoDueno: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // 🐾 Datos de la Mascota
                VStack(alignment: .leading, spacing: 12) {
                    Label("Datos de la Mascota", systemImage: "pawprint.fill")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    Text("ID: \(mascota.id.uuidString.prefix(8))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if isEditing {
                        TextField("Nombre", text: $nombre)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Picker("Especie", selection: $especie) {
                            ForEach(Especie.allCases, id: \.self) { especie in
                                Text(especie.rawValue).tag(especie)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        TextField("Raza", text: $raza)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        DatePicker("Nacimiento", selection: $fechaNacimiento, displayedComponents: .date)
                    } else {
                        Text("Nombre: \(mascota.nombre)")
                        Text("Especie: \(mascota.especie.rawValue)")
                        Text("Raza: \(mascota.raza)")
                        Text("Nacimiento: \(mascota.fechaNacimiento.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.Brand.primary.opacity(0.08))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                
                // 👤 Dueño
                if let owner = mascota.owner {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Dueño", systemImage: "person.fill")
                            .font(.headline)
                            .foregroundStyle(Color.Brand.primary)
                        
                        if isEditing {
                            TextField("Nombre del dueño", text: $nombreDueno)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Teléfono", text: $telefonoDueno)
                                .keyboardType(.phonePad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text("Nombre: \(owner.nombre)")
                            Text("Teléfono: \(owner.telefono)")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.Brand.primary.opacity(0.08))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                }
                
                // 📅 Citas
                VStack(alignment: .leading, spacing: 12) {
                    Label("Citas", systemImage: "calendar")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    let citasOrdenadas = mascota.citas.sorted { $0.fecha < $1.fecha }
                    if citasOrdenadas.isEmpty {
                        Text("Sin citas registradas")
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    } else {
                        ForEach(citasOrdenadas) { cita in
                            NavigationLink(destination: CitaDetailView(cita: cita)) {
                                HStack(spacing: 32) {
                                    Image(systemName: iconoServicio(cita.servicio))
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color.Brand.primary)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(cita.servicio.rawValue)
                                            .font(.headline)
                                            .foregroundStyle(Color.Brand.secondary)
                                        Text(cita.fecha.formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundStyle(Color.Brand.secondary)
                                        Text("Estado: \(cita.estado.rawValue)")
                                            .font(.caption)
                                            .foregroundStyle(cita.estado == .pendiente ? .orange : Color.Brand.secondary)
                                    }
                                    
                                    .frame(width: 250)
                                }
                                .padding(8)
                                .background(Color.Brand.primary.opacity(0.04))
                                .cornerRadius(12)
                            }
                        }
                    }
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
        .navigationTitle(mascota.nombre)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if isEditing {
                    Button("Guardar") {
                        guardarCambios()
                    }
                    .foregroundStyle(Color.Brand.primary)
                } else {
                    Button("Editar") {
                        activarEdicion()
                    }
                    .foregroundStyle(Color.Brand.primary)
                }
            }
        }
        .onAppear {
            cargarDatos()
        }
    }
    
    // MARK: - Métodos
    private func cargarDatos() {
        nombre = mascota.nombre
        especie = mascota.especie
        raza = mascota.raza
        fechaNacimiento = mascota.fechaNacimiento
        if let owner = mascota.owner {
            nombreDueno = owner.nombre
            telefonoDueno = owner.telefono
        }
    }
    
    private func activarEdicion() {
        isEditing = true
    }
    
    private func guardarCambios() {
        mascota.nombre = nombre
        mascota.especie = especie
        mascota.raza = raza
        mascota.fechaNacimiento = fechaNacimiento
        if let owner = mascota.owner {
            owner.nombre = nombreDueno
            owner.telefono = telefonoDueno
        }
        try? context.save()
        isEditing = false
    }
    
    // MARK: - Helpers
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
