//
//  FetchingTrajectory.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 21/02/2025.
//

import Foundation
import MapKit


class FetchingTrajectory {
    
    
    func getData(lineID: Int) async throws -> Data {
        
        let endpoint = "https://www.zditm.szczecin.pl/api/v1/trajectories/\(lineID)"
        print("called fetchTrajectory")
        
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
        
        
    }
    
    
    
    
    
}
