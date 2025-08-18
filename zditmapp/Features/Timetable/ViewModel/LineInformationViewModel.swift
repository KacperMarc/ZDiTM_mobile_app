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
    
    var number: Int
    @Published var information: LineInformation?
    
    init(number: Int) {
        self.number = number
    }
    
    func prepareData() async {
        self.information = try? await APIClient.request(from: APIEndpoint.lineInformation(number))
    }
}
