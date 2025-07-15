//
//  CustomAnnotationData.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 28/12/2024.
//
import Foundation
import MapKit
import Combine

class CustomAnnotation:NSObject, MKAnnotation, ObservableObject {
    @Published dynamic var coordinate: CLLocationCoordinate2D
    @Published dynamic var vehicle: Vehicle?

    init(coordinate: CLLocationCoordinate2D, vehicle: Vehicle?) {
        self.coordinate = coordinate
        self.vehicle = vehicle
        super.init()
    }
    func updateCoordinates(_ newCoordinate: CLLocationCoordinate2D) {
        self.coordinate = newCoordinate
    }
    func updateDelay(_ newDelay: Int) {
        self.vehicle?.punctuality = newDelay
        
    }
    func updateBearing(_ newBearing: Int) {
        self.vehicle?.bearing = newBearing
    }
}

