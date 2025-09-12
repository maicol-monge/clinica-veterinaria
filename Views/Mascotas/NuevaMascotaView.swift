import SwiftUI
import SwiftData

struct NuevaMascotaView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var owners: [Owner]
    
    @State private var nombre = ""
    @State private var especie: Especie = .perro
    @State private var raza = ""
    @State private var fechaNacimiento = Date()
    @State private var ownerSeleccionado: Owner?
    
    @State private var nuevoOwnerNombre = ""
    @State private var nuevoOwnerTelefono = ""
    @State private var crearNuevoOwner = false
    @State private var searchText = ""
    
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    
    var ownersFiltrados: [Owner] {
        owners.filter { owner in
            searchText.isEmpty ||
            owner.nombre.localizedCaseInsensitiveContains(searchText) ||
            owner.telefono.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // 🐾 Datos de la Mascota
                VStack(alignment: .leading, spacing: 12) {
                    Label("Datos de la Mascota", systemImage: "pawprint.fill")
                        .font(.headline)
                        .foregroundStyle(Color.Brand.primary)
                    
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
                                .padding(.top, 4)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(ownersFiltrados) { owner in
                                    Button {
                                        ownerSeleccionado = owner
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(owner.nombre)
                                                    .font(.headline)
                                                    .foregroundStyle(Color.Brand.secondary)
                                                Text(owner.telefono)
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color.Brand.secondary)
                                            }
                                            Spacer()
                                            if ownerSeleccionado == owner {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundStyle(Color.Brand.primary)
                                            }
                                        }
                                        .padding(8)
                                        .background(Color.Brand.primary.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                }
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
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.Brand.background)
        .navigationTitle("Nueva Mascota")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    if validarCampos() {
                        var owner: Owner?
                        if crearNuevoOwner {
                            let nuevoOwner = Owner(nombre: nuevoOwnerNombre, telefono: nuevoOwnerTelefono)
                            context.insert(nuevoOwner)
                            owner = nuevoOwner
                        } else {
                            owner = ownerSeleccionado
                        }
                        
                        let nuevaMascota = Mascota(
                            nombre: nombre,
                            especie: especie,
                            raza: raza,
                            fechaNacimiento: fechaNacimiento,
                            owner: owner
                        )
                        context.insert(nuevaMascota)
                        try? context.save()
                        dismiss()
                    }
                }
                .foregroundStyle(Color.Brand.primary)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
                    .foregroundStyle(.red)
            }
        }
        .alert("Error", isPresented: $mostrarAlerta) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(mensajeAlerta)
        }
    }
    
    private func validarCampos() -> Bool {
        if nombre.trimmingCharacters(in: .whitespaces).isEmpty {
            mensajeAlerta = "El nombre de la mascota es obligatorio."
            mostrarAlerta = true
            return false
        }
        if crearNuevoOwner {
            if nuevoOwnerNombre.isEmpty || nuevoOwnerTelefono.isEmpty {
                mensajeAlerta = "Debes ingresar nombre y teléfono del dueño."
                mostrarAlerta = true
                return false
            }
        } else if ownerSeleccionado == nil {
            mensajeAlerta = "Debes seleccionar un dueño existente."
            mostrarAlerta = true
            return false
        }
        return true
    }
}
