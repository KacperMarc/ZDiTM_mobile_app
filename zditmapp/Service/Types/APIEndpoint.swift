//
//  APIEndpoint.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 16/08/2025.
//

import Foundation

enum APIEndpoint: Endpoint {
    private static let zditmURL = URL(string: "https://www.zditm.szczecin.pl/api/v1")!
    private static let scrapeURL = URL(string: "http://127.0.0.1:3000/scrape")!
    private static let routesURL = URL(string: "https://api.traveltimeapp.com/v4/routes")!
    
    case stops, table(String), lines, lineInformation(Int), vehicles, trajectories(Int)
    
    var request: URLRequest {
        URLRequest(url: url)
    }
    
    var responseType: Decodable.Type {
        switch self {
        case .stops:
            return StopsResponse.self
        case .table:
            return DepartureTable.self
        case .lines:
            return LinesResponse.self
        case .lineInformation:
            return LineInformation.self
        case .vehicles:
            return VehiclesResponse.self
        case .trajectories:
            return GeoJSONResponse.self
        }
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
        case .lineInformation(let number):
            return "/\(number)"
        case .vehicles:
            return "/vehicles"
        case .trajectories(let lineID):
            return "/trajectories/\(lineID)"
        }
    }
    
}
