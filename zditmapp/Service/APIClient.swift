//
//  ApiClient.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 10/08/2025.
//

import Foundation

struct APIClient {
    
    func getVehicles() async throws -> [Vehicle] {
        let vehicleResponse: VehiclesResponse = try await APIClient.fetchData(from: APIEndpoint.vehicles) as! VehiclesResponse
        let vehicles = vehicleResponse.data
        return vehicles
    }
    
    func getDepartureTable(number: String) async throws -> DepartureTable {
        let departureTable: DepartureTable = try await APIClient.fetchData(from: APIEndpoint.table(number)) as! DepartureTable
        return departureTable
    }
        
    static func fetchData(from endpoint: Endpoint) async throws -> Decodable {
        
        let (data, response) = try await URLSession.shared.data(for: endpoint.request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(endpoint.responseType, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
}
