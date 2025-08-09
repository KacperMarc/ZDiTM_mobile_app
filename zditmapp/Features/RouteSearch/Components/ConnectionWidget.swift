//
//  ConnectionWidget.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 19/05/2025.
//
import UIKit
import Foundation

class ConnectionWidget: UIView {
    
    private let departureTime: String
    private let arrivalTime: String
    private let duration: Float
    private let vehicleWidgets: [VehicleWidget]
    
    init(deparureTime: String, arrivalTime: String, duration: Float, vehicleWidgets: [VehicleWidget]){
        self.departureTime = deparureTime
        self.arrivalTime = arrivalTime
        self.duration = duration
        self.vehicleWidgets = vehicleWidgets
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func SetupUI(){
        
    }
    
    lazy var departureArrivalStack: UIStackView = {
        
        lazy var departureLabel: UILabel = {
            let label = UILabel()
            return label
        }()
        lazy var arrivalLabel: UILabel = {
            let label = UILabel()
            return label
        }()

        
        let stack = UIStackView()
        return stack
    }()
    
    lazy var timesStack: UIStackView = {
        
    
        let stack = UIStackView()
        return stack
    }()
    
    lazy var vehiclesStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    lazy var widgetStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
}
