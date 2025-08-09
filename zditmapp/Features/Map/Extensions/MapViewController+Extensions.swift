//
//  MapViewController+Extensions.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 29/12/2024.
//

import UIKit
import MapKit

extension MapViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchLineTextField{
            viewModel.showRequestedLine = true
            viewModel.showVehicles = false
            updateMapView()
        }
        return true
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

extension MapViewController: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)  {
        if let customVehicleAnnotation = view.annotation as? CustomAnnotation,
           let vehicleId = customVehicleAnnotation.vehicle?.vehicle_id {
                let vehicleInfoVM = VehicleInformationViewModel(vehicleId: vehicleId, mapViewModel: viewModel)
                let vehicleInfoVC = VehicleInformationViewController(viewModel: vehicleInfoVM)
                vehicleInfoVC.modalPresentationStyle = .automatic
                
                if let sheet = vehicleInfoVC.sheetPresentationController {
                    sheet.prefersGrabberVisible = true
                    sheet.detents = [.medium()]
                }
                present(vehicleInfoVC, animated: true)
        } else {
            print("Niepoprawny typ adnotacji.")
        }
        if let customStopAnnotation = view.annotation as? CustomStop,
           let stopNumber = customStopAnnotation.stop?.number {
            let stopInfoVM =  StopInformationViewModel(stopNumber: stopNumber)
            let stopInfoVC = StopInformationViewController(viewModel: stopInfoVM)
            stopInfoVC.modalPresentationStyle = .pageSheet
            
            if let sheet = stopInfoVC.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.detents = [.medium()]
            }
            present(stopInfoVC, animated: true)
        }
    }
}


