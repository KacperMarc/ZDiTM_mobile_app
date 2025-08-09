//
//  LineInformationViewController+Extensions.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 21/04/2025.
//
import MapKit

extension LineInformationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
        
            return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        if let cluster = annotation as? MKClusterAnnotation {
                    let clusterView = mapView.dequeueReusableAnnotationView(
                        withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier
                    ) as? ClusterAnnotationView
                    clusterView?.annotation = cluster
            
                    return clusterView
        }
        if let customVehicleAnnotation = annotation as? CustomAnnotation {
            let reuseIdentifier = "customVehicleAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomVehicleView
            if annotationView == nil {
                annotationView = CustomVehicleView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            } else {
                annotationView?.annotation = annotation
            }
            if let vehicle = customVehicleAnnotation.vehicle {
                annotationView?.configure(
                    lineNumber: vehicle.line_number, delay: vehicle.punctuality, pointer: vehicle.bearing ?? 0
                )
            }
            annotationView?.clusteringIdentifier = nil
            
            return annotationView
        }
        
        if let customStopAnnotation = annotation as? CustomStop {
            let reuseIdentifier = "customStopAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomStopView
            if annotationView == nil {
                annotationView = CustomStopView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
}
