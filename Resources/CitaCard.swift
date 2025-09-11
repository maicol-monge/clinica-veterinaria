import SwiftUI

struct CitaCard: View {
    var cita: Cita

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(cita.servicio.rawValue)
                .font(.headline)
                .foregroundStyle(Color.Brand.primary)

            Text(cita.fecha, style: .date)
                .font(.subheadline)
                .foregroundStyle(Color.Brand.secondary)

            Text(cita.estado.rawValue)
                .font(.caption)
                .padding(6)
                .background(Color.Brand.primary.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Brand.primary.opacity(0.2))
        .cornerRadius(12)
    }
}
