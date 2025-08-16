//
//  APIEndpoint.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 16/08/2025.
//

import Foundation

enum APIEndpoint {
    private static let zditmURL = URL(string: "https://www.zditm.szczecin.pl/api/v1")!
    
    case stops, table(String), lines, vehicles, trajectories(Int)
    
    var request: URLRequest {
        URLRequest(url: url)
    }
    
    private var url: URL {
        APIEndpoint.zditmURL.appendingPathComponent(path)
    }
    
    private var path: String {
        switch self {
        case .stops:
            return "/stops"
        case .table(let number):
            return "/displays/\(number)"
        case .lines:
            return "/lines"
        case .vehicles:
            return "/vehicles"
        case .trajectories(let lineID):
            return "/trajectories/\(lineID)"
        }
    }
    
}
