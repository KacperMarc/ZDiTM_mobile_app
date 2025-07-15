//
//  LineTrajectory.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 21/02/2025.
//

import Foundation
struct GeoJSONResponse: Codable {
    let features: [GeoJSONFeature]
}

struct GeoJSONFeature: Codable {
    let geometry: GeoJSONGeometry
}

struct GeoJSONGeometry: Codable {
    let coordinates: [[Double]]
}
