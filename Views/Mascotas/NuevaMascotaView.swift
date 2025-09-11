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
        NavigationStack {
            Form {
                Section("Datos de la Mascota") {
                    TextField("Nombre", text: $nombre)
                    Picker("Especie", selection: $especie) {
                        ForEach(Especie.allCases, id: \.self) { especie in
                            Text(especie.rawValue)
                        }
                    }
                    TextField("Raza", text: $raza)
                    DatePicker("Fecha de Nacimiento", selection: $fechaNacimiento, displayedComponents: .date)
                }
                
                Section("Dueño") {
                    Toggle("Crear nuevo dueño", isOn: $crearNuevoOwner)
                    
                    if crearNuevoOwner {
                        TextField("Nombre del dueño", text: $nuevoOwnerNombre)
                        TextField("Teléfono", text: $nuevoOwnerTelefono)
                            .keyboardType(.phonePad)
                    } else {
                        TextField("Buscar dueño...", text: $searchText)
                        List(ownersFiltrados) { owner in
                            Button {
                                ownerSeleccionado = owner
                            } label: {
                                HStack {
                                    Text("\(owner.nombre) (\(owner.telefono))")
                                    if ownerSeleccionado == owner {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                        .frame(minHeight: 100, maxHeight: 200)
                    }
                }
            }
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
