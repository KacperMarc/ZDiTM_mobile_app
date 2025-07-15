//
//  DepartureTable.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 05/01/2025.
//

import Foundation

struct DepartureInfo: Codable {
    let line_number: String
    let direction: String
    let time_real: Int?
    let time_scheduled: String?
}

struct DepartureTable: Codable {
    let stop_name: String
    let stop_number: String
    var departures: [DepartureInfo]
    let message: String?
    let updated_at: String
}
