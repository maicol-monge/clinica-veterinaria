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
                        Picker("Seleccionar dueño", selection: $ownerSeleccionado) {
                            ForEach(owners) { owner in
                                Text("\(owner.nombre) (\(owner.telefono))")
                                    .tag(Optional(owner))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nueva Mascota")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
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
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
