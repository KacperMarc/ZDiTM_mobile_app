//
//  FetchingRoutes.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 17/05/2025.
//

import Foundation

class FetchingRoutes{
    
    static func fetchRoutes(_ connectionType: String, _ originLat: Float, _ originLng: Float,_ destLat: Float, _ destLng: Float, _ departureTime: String, _ appId: String, _ apiKey: String) async throws -> RouteResults {
        
        let endpointGet =  "https://api.traveltimeapp.com/v4/routes?type=\(connectionType)&origin_lat=\(originLat)&origin_lng=\(originLng)&destination_lat=\(destLat)&destination_lng=\(destLng)&departure_time=\(departureTime)&app_id=\(appId)&api_key=\(apiKey)"
        
        let endpointPost = "https://api.traveltimeapp.com/v4/routes"
        
        guard let url = URL(string: endpointPost) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        let body = RouteRequestBody(
            locations: [
                location(id: "1", coords: Coordinate(lat: destLat, lng: destLng)),
                location(id: "2", coords: Coordinate(lat: originLat, lng: originLng))
            ],
            departure_searches: [
                DepartureSearch(
                    id: "wyniki_odjazdow",
                    departure_location_id: "1",
                    arrival_location_ids: ["2"],
                    departure_time: departureTime,
                    properties: ["travel_time", "route"],
                    transportation: Transportation(type: connectionType)
                )
            ]
        )
        request.httpMethod = "POST"
        //headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(appId, forHTTPHeaderField: "X-Application-Id")
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.httpBody = try JSONEncoder().encode(body)
        let encodedData = request.httpBody
        print(String(data: encodedData!, encoding: .utf8)!)

        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(RouteResults.self, from: data)
        
    }
}
