//
//  MapViewModel.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 23/12/2024.
//

import Foundation
import MapKit
import Combine

class MapViewModel: ObservableObject {
    
     private let vehiclesService = FetchingVehicles()
     private let stopsService = FetchingStops()
    
     var locationManager: CLLocationManager?
     var timer: Timer?
     var showVehicles = false
     var showRequestedLine = false
     var showStops = false
     var showVehicleDetails = false
     @Published var vehicleAnnotations: [CustomAnnotation] = []
     @Published var stopAnnotations: [CustomStop] = []
     
    // MARK: - vehicles
    func stopRequest() {
        timer?.invalidate()
        timer = nil
        print("stopped timer")
    }
    
    @MainActor
    func updateVehiclesOnMapView(_ mapView: MKMapView, lineNumber: String?) {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
                    Task {
                        try await self?.updateVehicleDataAnnotations(on: (mapView), lineNumber: lineNumber)
                    }
                }
        }
        print("updated annotation on map")
    }
    
    @MainActor
    private func updateVehicleDataAnnotations(on mapView: MKMapView, lineNumber: String?) async throws {
        do {
            try await returnVehicleAnnotations(lineNumber: lineNumber)
            let newAnnotations = vehicleAnnotations
            let existingAnnotations = mapView.annotations.compactMap { $0 as? CustomAnnotation }

            for newAnnotation in newAnnotations {
                if let existingAnnotation = existingAnnotations.first(where: { $0.vehicle?.vehicle_id == newAnnotation.vehicle?.vehicle_id }) {
                    UIView.animate(withDuration: 0.5) {
                        existingAnnotation.updateCoordinates(newAnnotation.coordinate)
                        existingAnnotation.updateDelay(newAnnotation.vehicle!.punctuality)
                        existingAnnotation.updateBearing(newAnnotation.vehicle!.bearing ?? 0)
                    }
                    if let annotationView = mapView.view(for: existingAnnotation) as? CustomVehicleView {
                                        annotationView.configure(
                                            lineNumber: existingAnnotation.vehicle?.line_number ?? "",
                                            delay: existingAnnotation.vehicle?.punctuality ?? 0,
                                            pointer: existingAnnotation.vehicle?.bearing ?? 0
                                        )
                    }
                }
                let newAnnotationIDs = Set(newAnnotations.map { $0.vehicle?.vehicle_id })
                            for existingAnnotation in existingAnnotations {
                                if !newAnnotationIDs.contains(existingAnnotation.vehicle?.vehicle_id) {
                                    mapView.removeAnnotation(existingAnnotation)
                                }
                            }
            }
            print("Updated locations data")
            
        } catch {
            print("Error updating locations: \(error)")
        }
    }
    
    func addVehicleAnnotations(on mapView: MKMapView, lineNumber: String? = nil) async throws {
        do {
            try await returnVehicleAnnotations(lineNumber: lineNumber)
            DispatchQueue.main.async {
                //retain cycle?
                mapView.addAnnotations(self.vehicleAnnotations)
            }
        } catch {
            throw error
        }
    }

    private func returnVehicleAnnotations(lineNumber: String? = nil) async throws {
        do {
            var vehicles = try await vehiclesService.getData()

            let lineNumbers: [String]? = lineNumber?
                .components(separatedBy: " ")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            
            let filteredVehicles: [Vehicle]
            
            if let lineNumbers = lineNumbers, !lineNumbers.isEmpty {
                filteredVehicles = vehicles.filter { lineNumbers.contains($0.line_number) }
            } else {
                filteredVehicles = vehicles
            }
            
            let customAnnotations = filteredVehicles.map { vehicle -> CustomAnnotation in
                let coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
                return CustomAnnotation(coordinate: coordinate, vehicle: vehicle)
            }
            
            self.vehicleAnnotations = customAnnotations
            print("Wszystkie pojazdy: \(vehicleAnnotations.count)")
        } catch {
            print("Błąd: \(error)")
            throw error
        }
    }
    
    // MARK: - stops
    func addStopAnnotations(on mapView: MKMapView) async throws {
        do{
            try await returnStopAnnotations()
            DispatchQueue.main.async {
                mapView.addAnnotations(self.stopAnnotations)
            }
        }
        catch {
            print(error)
            throw error
        }
    }
    
    func returnStopAnnotations() async throws {
        do{
            let stops = try await stopsService.getData()
            let customAnnotations = stops.map {
                stop -> CustomStop in
                let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
                return CustomStop(coordinate: coordinate, stop: stop)
            }
            self.stopAnnotations = customAnnotations
        }
        catch {
            print(error)
            throw error
        }
    }
}
