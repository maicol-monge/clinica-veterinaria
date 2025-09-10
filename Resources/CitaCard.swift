
import SwiftUI

struct CitaCard: View {
    var cita: Cita
    var mascota: Mascota

    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.title2)
                .foregroundStyle(.brandPrimary)
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(mascota.nombre)
                    .font(.system(.title3, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("\(cita.servicio.rawValue) • \(cita.estado.rawValue)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)

                Text(cita.fecha, style: .date)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.brandSecondary.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}
