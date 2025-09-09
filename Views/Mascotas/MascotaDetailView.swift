


import SwiftUI

struct MascotaDetailView: View {
    let mascota: Mascota
    
    var body: some View {
        Form {
            Section("Datos de la Mascota") {
                Text("🐾 Nombre: \(mascota.nombre)")
                Text("Especie: \(mascota.especie.rawValue.capitalized)")
                Text("Raza: \(mascota.raza)")
                Text("Nacimiento: \(mascota.fechaNacimiento.formatted(date: .abbreviated, time: .omitted))")
            }
            
            Section("Datos del Dueño") {
                Text("👤 Nombre: \(mascota.nombreDueno)")
                Text("📞 Teléfono: \(mascota.telefonoDueno)")
            }
        }
        .navigationTitle(mascota.nombre)
    }
}
