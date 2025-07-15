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
    
    
    
    private let service = FetchingLineInformation()
    private let trajectoryVM = LineTrajectoryViewModel()
    private var number: Int
    @Published var information: LineInformation?
    
    init(number: Int) {
        self.number = number
    }
    
    func prepareData() async {
        self.information = try? await service.getData(number: number)
    }
    func addRoute(on mapView: MKMapView) async {
        await trajectoryVM.addRouteToMap(on: mapView, lineID: self.number)
    }
}
