import Foundation
import SwiftData

@Model
class Mascota {
    var nombre: String
    var especie: Especie
    var raza: String
    var fechaNacimiento: Date
    var nombreDueno: String
    var telefonoDueno: String
    
    @Relationship(deleteRule: .cascade) var citas: [Cita] = []
    
    init(nombre: String, especie: Especie, raza: String, fechaNacimiento: Date, nombreDueno: String, telefonoDueno: String) {
        self.nombre = nombre
        self.especie = especie
        self.raza = raza
        self.fechaNacimiento = fechaNacimiento
        self.nombreDueno = nombreDueno
        self.telefonoDueno = telefonoDueno
    }
}

@Model
class Cita {
    var fecha: Date
    var servicio: Servicio
    var detalle: String?
    var estado: EstadoCita
    
    var mascota: Mascota?
    
    init(fecha: Date, servicio: Servicio, detalle: String? = nil, estado: EstadoCita = .pendiente, mascota: Mascota? = nil) {
        self.fecha = fecha
        self.servicio = servicio
        self.detalle = detalle
        self.estado = estado
        self.mascota = mascota
    }
}

enum Especie: String, Codable, CaseIterable {
    case perro, gato, conejo
}

enum Servicio: String, Codable, CaseIterable {
    // Perros
    case banoBasico = "Baño básico"
    case banoUnas = "Baño con recorte de uñas"
    case banoEstetico = "Baño estético"
    case banoMedicado = "Baño medicado"
    
    // General
    case consulta = "Consulta médica"
    case emergencia = "Emergencia"
}

enum EstadoCita: String, Codable, CaseIterable {
    case pendiente = "Pendiente"
    case aceptada = "Aceptada"
    case rechazada = "Rechazada"
    case completada = "Completada"
}
