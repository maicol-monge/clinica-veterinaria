import SwiftUI
import SwiftData

struct CitasView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Cita.fecha, order: .forward) private var citas: [Cita]
    
    @State private var mostrarNuevaCita = false
    @State private var filtroEstado: EstadoCita? = nil
    
    // 🔎 Filtros de fecha
    @State private var fechaInicio: Date? = nil
    @State private var fechaFin: Date? = nil
    
    var citasFiltradas: [Cita] {
        citas.filter { cita in
            // Filtro por estado
            let pasaEstado = filtroEstado == nil || cita.estado == filtroEstado
            
            // Filtro por rango de fechas
            let pasaFechaInicio = fechaInicio == nil || cita.fecha >= fechaInicio!
            let pasaFechaFin = fechaFin == nil || cita.fecha <= fechaFin!
            
            return pasaEstado && pasaFechaInicio && pasaFechaFin
        }
    }
    
    var body: some View {
        VStack {
            // 🔎 Controles de filtro por fecha
            Form {
                Section("Filtrar por Fecha") {
                    DatePicker("Desde", selection: Binding(
                        get: { fechaInicio ?? Date() },
                        set: { fechaInicio = $0 }
                    ), displayedComponents: .date)
                    .environment(\.locale, Locale(identifier: "es"))
                    
                    DatePicker("Hasta", selection: Binding(
                        get: { fechaFin ?? Date() },
                        set: { fechaFin = $0 }
                    ), displayedComponents: .date)
                    .environment(\.locale, Locale(identifier: "es"))
                    
                    Button("Limpiar Filtros") {
                        fechaInicio = nil
                        fechaFin = nil
                        filtroEstado = nil
                    }
                    .foregroundColor(.red)
                }
            }
            .frame(height: 200) // Mantener compacta la sección de filtros
            
            List {
                ForEach(citasFiltradas) { cita in
                    NavigationLink {
                        CitaDetailView(cita: cita)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(cita.mascota?.nombre ?? "Sin mascota")
                                .font(.headline)
                            Text("\(cita.servicio.rawValue) • \(cita.fecha.formatted(date: .abbreviated, time: .shortened))")
                                .font(.subheadline)
                            Text("Estado: \(cita.estado.rawValue)")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("Citas")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filtrar Estado") {
                    Button("Todas") { filtroEstado = nil }
                    ForEach(EstadoCita.allCases, id: \.self) { estado in
                        Button(estado.rawValue) { filtroEstado = estado }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { mostrarNuevaCita = true }) {
                    Label("Agregar", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $mostrarNuevaCita) {
            NuevaCitaView()
        }
    }
}
