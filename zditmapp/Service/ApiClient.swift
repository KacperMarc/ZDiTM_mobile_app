//
//  ApiClient.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 10/08/2025.
//

import Foundation

struct ApiClient {
    
    func getDepartureTable(number: String) async throws -> DepartureTable {
        let departureTable: DepartureTable = try await ApiClient.fetchData(from: .table(number))
        return departureTable
    }
        
    private static func fetchData<T: Decodable>(from endpoint: APIEndpoint) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(for: endpoint.request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
}
