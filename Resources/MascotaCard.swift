import SwiftUI

struct MascotaCard: View {
    var mascota: Mascota

    var body: some View {
        HStack {
            Image(systemName: mascota.especie == .perro ? "dog.fill" : "cat.fill")
                .font(.title)
                .foregroundStyle(.brandPrimary)
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(mascota.nombre)
                    .font(.system(.title2, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("\(mascota.especie.rawValue.capitalized) • \(mascota.raza)")
                    .font(.system(.subheadline, design: .rounded))
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
