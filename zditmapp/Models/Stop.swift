//
//  Stop.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 01/01/2025.
//

import Foundation





struct Stop: Codable {
    
    let id: Int
    let number: String
    let name: String
    let latitude: Double
    let longitude: Double
    let request_stop: Bool
    let park_and_ride: Bool
    let railway_station_name: String?
    let updated_at: String
}
struct StopsResponse: Codable {
    let data: [Stop]
}
