import SwiftUI

struct MascotaCard: View {
    var mascota: Mascota

    var body: some View {
        HStack {
            // Icono según especie
            Image(systemName: mascota.especie == .perro ? "pawprint.fill" :
                                mascota.especie == .gato ? "cat.fill" : "hare.fill")
                .font(.system(size: 28))
                .foregroundStyle(Color.Brand.primary)
                .padding(.trailing, 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(mascota.nombre)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("\(mascota.especie.rawValue.capitalized) • \(mascota.raza)")
                    .font(.system(size: 15, design: .rounded))
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
