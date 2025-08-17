//
//  LineInformationViewModel.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 16/02/2025.
//

import Foundation
import UIKit
import MapKit

class LineInformationViewModel:ObservableObject {
    
    private let trajectoryVM = LineTrajectoryViewModel()
    private var number: Int
    @Published var information: LineInformation?
    
    init(number: Int) {
        self.number = number
    }
    
    func prepareData() async {
        self.information = try? await APIClient.request(from: APIEndpoint.lineInformation(number))
    }
    
    func addRoute(on mapView: MKMapView) async {
        try? await trajectoryVM.addRouteToMap(on: mapView, lineID: self.number)
    }
}
