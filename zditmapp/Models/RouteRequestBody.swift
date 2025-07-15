//
//  RouteRequestBody.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 18/05/2025.
//
import Foundation



struct location: Codable {
    var id: String
    var coords: Coordinate
}

struct MaxChanges: Codable {
    var enabled: Bool
    var limit: Int
}

struct Transportation: Codable {
    var type: String
    var walking_time: Int?
    var maxChanges: MaxChanges?
}

struct DepartureSearch: Codable {
    var id: String
    var departure_location_id: String
    var arrival_location_ids: [String]
    var departure_time: String
    var properties: [String]
    var transportation: Transportation
}

struct RouteRequestBody: Codable {
    var locations: [location]
    var departure_searches: [DepartureSearch]
}
