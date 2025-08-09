//
//  FetchingDepartureTables.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 05/01/2025.
//

import Foundation

class FetchingDepartureTables {
    func getTable(number: String) async throws -> DepartureTable {
        

        let endpoint = "https://www.zditm.szczecin.pl/api/v1/displays/\(number)"
        
        guard let url = URL(string: endpoint) else { throw ZDITMError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ZDITMError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            let tableResponse = try decoder.decode(DepartureTable.self, from: data)
            return tableResponse
            }
        catch {
            throw ZDITMError.invalidData
        }
    }
}
