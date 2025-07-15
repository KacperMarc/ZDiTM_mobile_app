//
//  Route.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 18/05/2025.
//

import Foundation

struct Coordinate: Codable {
    var lat: Float
    var lng: Float
}

struct RouteSegment: Codable {
    var id: Int
    var type: String
    var mode: String
    var directions: String
    var distance: Int
    var travel_time: Int
    var coords: [Coordinate]
}

struct RouteObject: Codable {
    var departure_time: Date
    var arrival_time: Date?
    var parts: [RouteSegment]
}

struct Properties: Codable {
    var route: RouteObject
}

struct Location: Codable {
    var id: String
    var properties: [Properties]
}

struct Route: Codable {
    var search_id: String
    var locations: [Location]
    var unreachable: [String]
}

struct RouteResults: Codable {
    var results: [Route]
}


