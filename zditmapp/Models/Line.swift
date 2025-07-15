//
//  Line.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 13/02/2025.
//

import Foundation

struct Line: Codable {
    let id: Int
    let number: String
    let type: String
    let subtype: String
    let vehicle_type: String
    let on_demand: Bool
    let highlited: Bool?
    let sort_order: Int
    let updated_at: String
}
struct LinesResponse: Codable {
    let data: [Line]
}
