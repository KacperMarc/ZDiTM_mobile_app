//
//  CustomStopAnnotation.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 01/01/2025.
//

import MapKit


class CustomStopView: MKMarkerAnnotationView {
    
    static let reuseID = "stopAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "stop"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor(red: 30/255, green: 56/255, blue: 140/255, alpha: 1)
        glyphImage = .przystanek
    }
    
    
    
}
