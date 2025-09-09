

import SwiftUI
import SwiftData

struct NuevaMascotaView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var nombre = ""
    @State private var especie: Especie = .perro
    @State private var raza = ""
    @State private var fechaNacimiento = Date()
    @State private var nombreDueno = ""
    @State private var telefonoDueno = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Datos de la Mascota") {
                    TextField("Nombre", text: $nombre)
                    Picker("Especie", selection: $especie) {
                        ForEach(Especie.allCases, id: \.self) { especie in
                            Text(especie.rawValue.capitalized)
                        }
                    }
                    TextField("Raza", text: $raza)
                    DatePicker("Fecha de Nacimiento", selection: $fechaNacimiento, displayedComponents: .date)
                }
                
                Section("Datos del Dueño") {
                    TextField("Nombre del Dueño", text: $nombreDueno)
                    TextField("Teléfono", text: $telefonoDueno)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Nueva Mascota")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let nueva = Mascota(
                            nombre: nombre,
                            especie: especie,
                            raza: raza,
                            fechaNacimiento: fechaNacimiento,
                            nombreDueno: nombreDueno,
                            telefonoDueno: telefonoDueno
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
