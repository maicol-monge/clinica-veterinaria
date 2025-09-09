//
//  CitaDetailView.swift
//  clinica-veterinaria
//
//  Created by Luis Vasquez on 8/9/25.
//


import SwiftUI
import SwiftData

struct CitaDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var cita: Cita
    
    var body: some View {
        Form {
            Section("Información de la Cita") {
                Text("📅 Fecha: \(cita.fecha.formatted(date: .abbreviated, time: .shortened))")
                Text("Servicio: \(cita.servicio.rawValue)")
                if let detalle = cita.detalle, !detalle.isEmpty {
                    Text("Detalle: \(detalle)")
                }
                Text("Estado: \(cita.estado.rawValue)")
            }
            
            if let mascota = cita.mascota {
                Section("Mascota") {
                    Text("🐾 \(mascota.nombre)")
                    Text("Especie: \(mascota.especie.rawValue.capitalized)")
                    Text("Dueño: \(mascota.nombreDueno)")
                }
            }
            
            Section("Acciones") {
                Button("✅ Aceptar") {
                    cita.estado = .aceptada
                    try? context.save()
                }
                Button("❌ Rechazar") {
                    cita.estado = .rechazada
                    try? context.save()
                }
                Button("✔️ Completar") {
                    cita.estado = .completada
                    try? context.save()
                }
            }
        }
        .navigationTitle("Cita")
    }
}
