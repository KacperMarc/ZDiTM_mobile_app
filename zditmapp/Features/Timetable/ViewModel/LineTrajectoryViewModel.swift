//
//  LineTrajectoryViewModel.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 21/02/2025.
//

import Foundation
import MapKit

class LineTrajectoryViewModel {
    
    func addRouteToMap(on map: MKMapView, lineID: Int) async throws {
        do {
            let polylines = try await decode(lineID)
            await returnLineRoute(on: map, polylines: polylines)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    private func decode(_ lineID: Int) async throws -> [MKPolyline] {
        let decodedData: GeoJSONResponse = try await APIClient.request(from: APIEndpoint.trajectories(lineID))
        var polylines: [MKPolyline] = []
        
        for coordinate in decodedData.features {
            let coordinates = coordinate.geometry.coordinates.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            polylines.append(polyline)
        }
        
        return polylines
    }
    
    private func returnLineRoute(on map: MKMapView, polylines: [MKPolyline]) async {
        await MainActor.run {
            map.addOverlays(polylines)
            var routeRect = MKMapRect.null
            
            for polyline in polylines {
                routeRect = routeRect.union(polyline.boundingMapRect)
            }
            
            let edgePadding = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
            map.setVisibleMapRect(routeRect, edgePadding: edgePadding, animated: true)
        }
    }
}
