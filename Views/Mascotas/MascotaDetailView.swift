import SwiftUI
import SwiftData

struct MascotaDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var mascota: Mascota
    
    // Estado edición
    @State private var isEditing = false
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    
    // Campos mascota
    @State private var nombre: String = ""
    @State private var especie: Especie = .perro
    @State private var raza: String = ""
    @State private var fechaNacimiento: Date = Date()
    
    // Dueño
    @State private var crearNuevoOwner = false
    @State private var nuevoOwnerNombre = ""
    @State private var nuevoOwnerTelefono = ""
    
    @State private var searchText = ""
    @Query private var owners: [Owner]
    @State private var ownerSeleccionado: Owner?
    
    // 🔑 Filtro por estado de las citas
    @State private var estadoSeleccionado: EstadoCita? = nil  // nil = todos
    
    var ownersFiltrados: [Owner] {
        owners.filter { owner in
            searchText.isEmpty ||
            owner.nombre.localizedCaseInsensitiveContains(searchText) ||
            owner.telefono.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                HStack {
                    if isEditing {
                        Button {
                            isEditing = false
                            cargarDatos()
                        } label: {
                            Label("Cancelar", systemImage: "xmark.circle.fill")
                                .bold()
                        }
                        .foregroundStyle(.red)
                    }
                    
                    Spacer()
                    
                    if isEditing {
                        Button {
                            guardarCambios()
                        } label: {
                            Label("Guardar", systemImage: "checkmark.circle.fill")
                                .bold()
                        }
                        .foregroundStyle(Color.Brand.primary)
                    } else {
                        Button {
                            activarEdicion()
                        } label: {
                            Label("Editar", systemImage: "pencil.circle.fill")
                                .bold()
                        }
                        .foregroundStyle(Color.Brand.primary)
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                .frame(height: 40) // aumenté un poco para que los iconos respiren
            }

            VStack(spacing: 20) {
                
                // 🐾 Datos de la Mascota
                VStack(alignment: .leading, spacing: 12) {
                    Label("Datos de la Mascota", systemImage: "pawprint.fill")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    Text("ID: \(mascota.id.uuidString.prefix(8))")
                        .font(.caption)
                        .foregroundStyle(Color.Brand.secondary)
                    
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
                VStack(alignment: .leading, spacing: 12) {
                    Label("Dueño", systemImage: "person.fill")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    if isEditing {
                        Toggle("Crear nuevo dueño", isOn: $crearNuevoOwner)
                        
                        if crearNuevoOwner {
                            TextField("Nombre del dueño", text: $nuevoOwnerNombre)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Teléfono", text: $nuevoOwnerTelefono)
                                .keyboardType(.phonePad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            TextField("Buscar dueño...", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if ownersFiltrados.isEmpty {
                                Text("No se encontraron dueños")
                                    .foregroundStyle(Color.Brand.secondary)
                            } else {
                                ForEach(ownersFiltrados) { owner in
                                    Button {
                                        ownerSeleccionado = owner
                                    } label: {
                                        HStack {
                                            Text("\(owner.nombre) (\(owner.telefono))")
                                                .foregroundStyle(Color.Brand.secondary)
                                            if ownerSeleccionado == owner {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(Color.Brand.primary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        if let owner = mascota.owner {
                            Text("Nombre: \(owner.nombre)")
                            Text("Teléfono: \(owner.telefono)")
                        } else {
                            Text("Sin dueño asignado")
                                .foregroundStyle(Color.Brand.secondary)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.Brand.primary.opacity(0.08))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                
                

                // 📅 Citas
                VStack(alignment: .leading, spacing: 12) {
                    Label("Citas", systemImage: "calendar")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
                    // Picker de estado
                    Picker("Estado", selection: $estadoSeleccionado) {
                        Text("Todos").tag(EstadoCita?.none)
                        ForEach(EstadoCita.allCases, id: \.self) { estado in
                            Text(estado.rawValue.capitalized).tag(Optional(estado))
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 4)
                    
                    // Filtrar y ordenar citas
                    let citasFiltradas = mascota.citas
                        .filter { estadoSeleccionado == nil || $0.estado == estadoSeleccionado }
                        .sorted { $0.fecha > $1.fecha }

                    if citasFiltradas.isEmpty {
                        Text("Sin citas registradas")
                            .foregroundStyle(Color.Brand.secondary)
                            .padding(.top, 4)
                    } else {
                        ForEach(citasFiltradas) { cita in
                            NavigationLink(destination: CitaDetailView(cita: cita)) {
                                HStack(spacing: 12) {
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
                                .background(Color.Brand.primary.opacity(0.05))
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
        

        .onAppear {
            cargarDatos()
        }
        .alert("Error", isPresented: $mostrarAlerta) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mensajeAlerta)
        }
    }
    
    // MARK: - Métodos
    private func cargarDatos() {
        nombre = mascota.nombre
        especie = mascota.especie
        raza = mascota.raza
        fechaNacimiento = mascota.fechaNacimiento
        if let owner = mascota.owner {
            ownerSeleccionado = owner
            nuevoOwnerNombre = owner.nombre
            nuevoOwnerTelefono = owner.telefono
        }
    }
    
    private func activarEdicion() {
        isEditing = true
    }
    
    private func guardarCambios() {
        // Validaciones
        guard !nombre.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeAlerta = "El nombre de la mascota no puede estar vacío."
            mostrarAlerta = true
            return
        }
        guard !raza.trimmingCharacters(in: .whitespaces).isEmpty else {
            mensajeAlerta = "La raza no puede estar vacía."
            mostrarAlerta = true
            return
        }
        
        if crearNuevoOwner {
            guard !nuevoOwnerNombre.trimmingCharacters(in: .whitespaces).isEmpty else {
                mensajeAlerta = "El nombre del dueño no puede estar vacío."
                mostrarAlerta = true
                return
            }
            guard nuevoOwnerTelefono.count >= 8 else {
                mensajeAlerta = "El teléfono debe tener al menos 8 dígitos."
                mostrarAlerta = true
                return
            }
        } else if ownerSeleccionado == nil {
            mensajeAlerta = "Debes seleccionar un dueño existente o crear uno nuevo."
            mostrarAlerta = true
            return
        }
        
        // Guardar cambios
        mascota.nombre = nombre
        mascota.especie = especie
        mascota.raza = raza
        mascota.fechaNacimiento = fechaNacimiento
        
        if crearNuevoOwner {
            let nuevoOwner = Owner(nombre: nuevoOwnerNombre, telefono: nuevoOwnerTelefono)
            context.insert(nuevoOwner)
            mascota.owner = nuevoOwner
        } else {
            mascota.owner = ownerSeleccionado
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
