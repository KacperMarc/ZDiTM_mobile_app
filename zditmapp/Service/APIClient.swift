//
//  ApiClient.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 10/08/2025.
//

import Foundation

struct APIClient {
    
    static func request<T: Decodable>(from endpoint: APIEndpoint, as type: T.Type = T.self) async throws -> T {
        guard let data = try await fetchData(from: endpoint) as? T else {
            throw APIError.invalidData
        }
        return data
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
