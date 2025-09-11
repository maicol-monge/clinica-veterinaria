import SwiftUI

struct MascotaDetailView: View {
    var mascota: Mascota
    
    var body: some View {
        List {
            Section("Datos de la Mascota") {
                Text("ID: \(mascota.id.uuidString.prefix(8))") // mostrar solo 8 caracteres para que no sea tan largo
                Text("Nombre: \(mascota.nombre)")
                Text("Especie: \(mascota.especie.rawValue)")
                Text("Raza: \(mascota.raza)")
                Text("Nacimiento: \(mascota.fechaNacimiento.formatted(date: .abbreviated, time: .omitted))")
            }
            
            if let owner = mascota.owner {
                Section("Dueño") {
                    Text("Nombre: \(owner.nombre)")
                    Text("Teléfono: \(owner.telefono)")
                }
            }
            
            Section("Citas") {
                let citasOrdenadas = mascota.citas.sorted { $0.fecha < $1.fecha }
                if citasOrdenadas.isEmpty {
                    Text("Sin citas registradas")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(citasOrdenadas) { cita in
                        NavigationLink(destination: CitaDetailView(cita: cita)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(cita.servicio.rawValue)
                                    .font(.headline)
                                Text(cita.fecha.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("Estado: \(cita.estado.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(cita.estado == .pendiente ? .orange : .secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(mascota.nombre)
    }
}
