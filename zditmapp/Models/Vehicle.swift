//
//  Vehicle.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 01/01/2025.
//

import Foundation

struct VehicleTicketMachine: Codable {
    let cards: Bool
    let coins: Bool
}

struct Vehicle: Codable {
    let line_id: Int
    let line_number: String
    let line_type: String
    let line_subtype: String
    let vehicle_type: String
    let vehicle_id: Int
    let vehicle_number: String
    let vehicle_model: String?
    let vehicle_low_floor: Bool?
    let vehicle_ticket_machine: VehicleTicketMachine?
    let route_variant_number: Int
    let service: String
    let direction: String?
    let previous_stop: String?
    let next_stop: String?
    let latitude: Double
    let longitude: Double
    var bearing: Int?
    let velocity: Int
    var punctuality: Int
    let updated_at: String
}


struct VehiclesResponse: Codable {
    let data: [Vehicle]
}
