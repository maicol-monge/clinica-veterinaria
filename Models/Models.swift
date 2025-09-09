import Foundation
import SwiftData

// MARK: - Dueño
@Model
class Owner {
    var nombre: String
    var telefono: String
    @Relationship(deleteRule: .cascade) var mascotas: [Mascota] = []

    init(nombre: String, telefono: String) {
        self.nombre = nombre
        self.telefono = telefono
    }
}

// MARK: - Mascota
@Model
class Mascota {
    var nombre: String
    var especie: Especie
    var raza: String
    var fechaNacimiento: Date
    @Relationship(deleteRule: .nullify) var owner: Owner?
    @Relationship(deleteRule: .cascade) var citas: [Cita] = []

    init(nombre: String, especie: Especie, raza: String, fechaNacimiento: Date, owner: Owner?) {
        self.nombre = nombre
        self.especie = especie
        self.raza = raza
        self.fechaNacimiento = fechaNacimiento
        self.owner = owner
    }
}

// MARK: - Cita
@Model
class Cita {
    var fecha: Date
    var servicio: Servicio
    var estado: EstadoCita
    var detalle: String?
    @Relationship(deleteRule: .nullify) var mascota: Mascota?

    init(fecha: Date, servicio: Servicio, estado: EstadoCita = .pendiente, detalle: String? = nil, mascota: Mascota?) {
        self.fecha = fecha
        self.servicio = servicio
        self.estado = estado
        self.detalle = detalle
        self.mascota = mascota
    }
}

// MARK: - Enums
enum Especie: String, CaseIterable, Codable {
    case perro = "Perro"
    case gato = "Gato"
    case conejo = "Conejo"
}

enum Servicio: String, CaseIterable, Codable {
    case consulta = "Consulta médica"
    case emergencia = "Emergencia"

    // Solo para perros
    case banoBasico = "Baño básico"
    case banoUñas = "Baño con recorte de uñas"
    case banoEstetico = "Baño estético"
    case banoMedicado = "Baño medicado"
}

enum EstadoCita: String, CaseIterable, Codable {
    case pendiente = "Pendiente"
    case aceptada = "Aceptada"
    case rechazada = "Rechazada"
    case completada = "Completada"
}
