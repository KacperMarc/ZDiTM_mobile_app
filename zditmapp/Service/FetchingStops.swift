//
//  FetchingStops.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 31/12/2024.
//

import Foundation
final class FetchingStops {
     func getData() async throws -> [Stop] {
        
        let endpoint = "https://www.zditm.szczecin.pl/api/v1/stops"
        
        guard let url = URL(string: endpoint) else {
            
            throw APIError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse }

        do {
            let decoder = JSONDecoder()
            let stopsResponse = try decoder.decode(StopsResponse.self, from: data)
            return stopsResponse.data
        } catch {
            throw APIError.invalidData
        }
        

    }
    
    
    

}
