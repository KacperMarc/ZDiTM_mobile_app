//
//  dataFetching.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 22/12/2024.
//

import Foundation

final class FetchingVehicles {
    
     func getData() async throws -> [Vehicle] {
        let endpoint = "https://www.zditm.szczecin.pl/api/v1/vehicles"
        guard let url = URL(string: endpoint) else {
            
            throw ZDITMError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw ZDITMError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            let vehiclesResponse = try decoder.decode(VehiclesResponse.self, from: data)
            return vehiclesResponse.data
            
        } catch {
            throw ZDITMError.invalidData
        }
        
    }
}
