//
//  FetchingLineInformation.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 19/02/2025.
//

import Foundation

class FetchingLineInformation {
    func getData(number: Int) async throws -> LineInformation {
        
        let endpoint = "http://127.0.0.1:3000/scrape/\(number)"
        print("called lineInformation")

        guard let url = URL(string: endpoint) else {
            
            throw APIError.invalidURL }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw APIError.invalidResponse
            }

            return try JSONDecoder().decode(LineInformation.self, from: data)
        
        
    }
}
