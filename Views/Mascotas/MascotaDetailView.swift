import SwiftUI

struct MascotaDetailView: View {
    var mascota: Mascota
    
    var body: some View {
        List {
            Section("Datos de la Mascota") {
                Text("Nombre: \(mascota.nombre)")
                Text("Especie: \(mascota.especie.rawValue)")
                Text("Raza: \(mascota.raza)")
                Text("Fecha de nacimiento: \(mascota.fechaNacimiento.formatted(date: .abbreviated, time: .omitted))")
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
                } else {
                    ForEach(citasOrdenadas) { cita in
                        VStack(alignment: .leading) {
                            Text("\(cita.fecha.formatted(date: .abbreviated, time: .shortened))")
                            Text(cita.servicio.rawValue)
                            Text("Estado: \(cita.estado.rawValue)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(mascota.nombre)
    }
}
