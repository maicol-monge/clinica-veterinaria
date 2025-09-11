import SwiftUI

extension Color {
    enum Brand {
        // Colores desde Assets
        static let primary = Color("BrandPrimary")       // Naranja
        static let secondary = Color("BrandSecondary")   // Gris claro
        
        // Fallbacks si no quieres usar Assets
        static let fallbackPrimary = Color(red: 1.0, green: 0.45, blue: 0.0)
        static let fallbackSecondary = Color(red: 0.95, green: 0.95, blue: 0.95)
    }
}
