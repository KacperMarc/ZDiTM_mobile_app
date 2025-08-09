//
//  VehicleWidget.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 23/05/2025.
//

import UIKit
import Foundation

class VehicleWidget: UIView {
    private let line: String
    private let isWalk: Bool?
    private let meters: Int?
    private let transportType: TransportType
        
    init(line: String, transportType: TransportType, isWalk: Bool?, meters: Int?){
        self.line = line
        self.isWalk = isWalk
        self.meters = meters
        self.transportType = transportType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func detectTransportType(from line: String, isWalk: Bool, meters: String) -> TransportType {
        
        if(isWalk) {  return .walk(meters: meters)  }
        
        if let titleIsNumber = Int(line) {
            switch titleIsNumber {
                case 1...12:
                    return .tram(number: line)
                case 51...244:
                    return .bus(number: line)
                case 904...909:
                    return .bus(number: line)
                case 521...536:
                    return .nightBus(number: line)
                default:
                    return .unknown(number: line)
            }
        } else {
            switch line.uppercased() {
                case "A", "B", "C":
                    return .bus(number: line)
            
                default:
                    return .unknown(number: line)
            }
        }
    }

    enum TransportType {
        case bus(number: String)
        case fastBus(number: String)
        case nightBus(number: String)
        case tram(number: String)
        case walk(meters: String)
        case unknown(number: String)
        
        var iconName: String {
            switch self {
                case .bus: return "bus"
                case .tram: return "tram"
                case .walk: return "figure.walk"
                case .fastBus: return "bus"
                case .nightBus: return "bus"
                case .unknown: return "questionMark"
                    
            }
        }
        var iconColor: UIColor {
            switch self {
                case .bus:  return UIColor(red: 130/255, green: 188/255, blue: 0/255, alpha: 1)
                case .fastBus: return UIColor(red: 227/255, green: 6/255, blue: 19/255, alpha: 1)
                case .nightBus: return .black
                case .tram: return UIColor(red: 0/255, green: 159/255, blue: 227/255, alpha: 1)
                case .walk: return .systemGray
                case .unknown: return .systemGray
            }
        }
        
    }
    
    // MARK: - UI Components
    lazy var transportIconView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = transportType.iconColor
            imageView.image = UIImage(systemName: transportType.iconName)
            return imageView
    }()
    
    lazy var lineNumber: UILabel = {
        let label = UILabel()
        label.text = line
        return label
    }()
    
    lazy var widgetStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [transportIconView, lineNumber])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()
    
    func SetupUI(){
        
    }
    
}
