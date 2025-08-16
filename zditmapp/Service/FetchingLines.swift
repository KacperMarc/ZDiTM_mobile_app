//
//  FetchingLines.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 13/02/2025.
//

import Foundation

class FetchingLines {
    
    private let endpoint = URL(string: "https://www.zditm.szczecin.pl/api/v1/lines")
    
    func getData() async throws -> [Line] {
        guard let url = endpoint else { throw ZDITMError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ZDITMError.invalidResponse
        }
        
        return try JSONDecoder().decode(LinesResponse.self, from: data).data
    }
}
