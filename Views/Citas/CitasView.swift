import SwiftUI
import SwiftData

struct CitasView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Cita.fecha, order: .forward) private var citas: [Cita]
    
    @State private var mostrarNuevaCita = false
    @State private var filtroEstado: EstadoCita? = nil
    
    var citasFiltradas: [Cita] {
        citas.filter { cita in
            filtroEstado == nil || cita.estado == filtroEstado
        }
    }
    
    var body: some View {
        List {
            ForEach(citasFiltradas) { cita in
                NavigationLink {
                    CitaDetailView(cita: cita)
                } label: {
                    VStack(alignment: .leading) {
                        Text(cita.mascota?.nombre ?? "Sin mascota")
                            .font(.headline)
                        Text("\(cita.servicio.rawValue) - \(cita.fecha.formatted(date: .abbreviated, time: .shortened))")
                        Text("Estado: \(cita.estado.rawValue)").foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Citas")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filtrar") {
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
