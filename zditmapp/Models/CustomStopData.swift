//
//  CustomStopData.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 01/01/2025.
//
import MapKit

class CustomStop:NSObject, MKAnnotation{
    
    
    var coordinate: CLLocationCoordinate2D
    var stop: Stop?
    
    init(coordinate: CLLocationCoordinate2D, stop: Stop?){
        self.coordinate = coordinate
        self.stop = stop
    }
}

