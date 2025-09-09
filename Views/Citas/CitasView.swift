//
//  CitasView.swift
//  clinica-veterinaria
//
//  Created by Luis Vasquez on 8/9/25.
//


import SwiftUI
import SwiftData

struct CitasView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Cita.fecha) private var citas: [Cita]
    
    @State private var mostrarNuevaCita = false
    
    var body: some View {
        List {
            ForEach(citas) { cita in
                NavigationLink(cita.servicio.rawValue) {
                    CitaDetailView(cita: cita)
                }
            }
            .onDelete { indices in
                for index in indices {
                    context.delete(citas[index])
                }
                try? context.save()
            }
        }
        .navigationTitle("Citas")
        .toolbar {
            Button(action: { mostrarNuevaCita = true }) {
                Label("Agregar", systemImage: "plus")
            }
        }
        .sheet(isPresented: $mostrarNuevaCita) {
            NuevaCitaView()
        }
    }
}
