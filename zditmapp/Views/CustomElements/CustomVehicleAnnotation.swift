//
//  CustomMapAnnotation.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 24/12/2024.
//
import MapKit
import UIKit
import Foundation



final class CustomVehicleView: MKAnnotationView {
    
    static let reuseID = "vehicleAnnotation"

    
    

    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        image = drawAnnotation(lineNumber: "", delay: 0, pointerAngle: 0)
        
        displayPriority = .required
        clusteringIdentifier = nil
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawAnnotation(lineNumber: String?, delay: Int, pointerAngle: Int?) -> UIImage {
        
        func returnLineColor(lineNumber: String!) -> UIColor {
            
            if let lineIsNumber = Int(lineNumber!) {
                switch lineIsNumber {
                case 1...11:
                    return UIColor(red: 0/255, green: 159/255, blue: 227/255, alpha: 1)
                case 51...244:
                    return UIColor(red: 130/255, green: 188/255, blue: 0/255, alpha: 1)
                case 521...536:
                    return .black
                default:
                    return .gray
                }
                
            }
            else {
                switch lineNumber!.uppercased() {
                case "A", "B", "C":
                    return UIColor(red: 227/255, green: 6/255, blue: 19/255, alpha: 1)
                default :
                    return .gray
                }
            }
        }
        func returnDelayColor() -> UIColor {
            return delay < 0 ? .red : .systemGreen
        }
        
        
        let lineColor = returnLineColor(lineNumber: lineNumber!)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 70, height:70)) // Powiększony, by trójkąt nie był ucięty
        return renderer.image { _ in
            let center = CGPoint(x: 35, y: 35) // Środek koła
            
            // Rysowanie tła koła
            UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 60, height: 60)).fill()
            
            // Wypełnienie koła `lineColor`
            lineColor.setFill()
            UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 60, height: 60)).fill()
            
            // Wypełnienie wewnętrznego koła kolorem białym
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: 50, height: 50)).fill()
            
            // Atrybuty tekstu
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)
            ]
            
            let attributesSmall = [
                NSAttributedString.Key.foregroundColor: returnDelayColor(),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
            ]
            
            // Teksty
            let text = "\(lineNumber ?? "")"
            let text2 = "\(delay)"

            // Obliczanie rozmiarów tekstów
            let textSize = text.size(withAttributes: attributes)
            let text2Size = text2.size(withAttributes: attributesSmall)

            // Pozycjonowanie tekstów
            let textRect = CGRect(x: center.x - textSize.width / 2,
                                  y: center.y - textSize.height / 2 - 5,
                                  width: textSize.width, height: textSize.height)
            
            let text2Rect = CGRect(x: center.x - text2Size.width / 2,
                                   y: textRect.maxY + 2,
                                   width: text2Size.width, height: text2Size.height)
            
            // Rysowanie tekstów
            text.draw(in: textRect, withAttributes: attributes)
            text2.draw(in: text2Rect, withAttributes: attributesSmall)

            guard let pointerAngle = pointerAngle, pointerAngle != 0 else { return }
            
            let direction = CGFloat(pointerAngle - 90) * (.pi / 180)

            let circleRadius: CGFloat = 30 // Promień koła
            let triangleSize: CGFloat = 14  // Rozmiar trójkąta
            let offset: CGFloat = 7 // Odsunięcie trójkąta poza obwód koła

            // Punkt na zewnątrz obwodu koła
            let triangleCenter = CGPoint(
                x: center.x + (circleRadius + offset) * cos(direction),
                y: center.y + (circleRadius + offset) * sin(direction)
            )

            // Obliczenie trzech punktów trójkąta
            let p1 = triangleCenter
            let p2 = CGPoint(
                x: p1.x - triangleSize * cos(direction - .pi / 6),
                y: p1.y - triangleSize * sin(direction - .pi / 6)
            )
            let p3 = CGPoint(
                x: p1.x - triangleSize * cos(direction + .pi / 6),
                y: p1.y - triangleSize * sin(direction + .pi / 6)
            )

            // Ścieżka trójkąta
            let trianglePath = UIBezierPath()
            trianglePath.move(to: p1)
            trianglePath.addLine(to: p2)
            trianglePath.addLine(to: p3)
            trianglePath.close()

            UIColor.black.setFill()
            trianglePath.fill()

        }


        
    }
    
    func configure(lineNumber: String, delay: Int,
                   pointer: Int?) {
    
        image = drawAnnotation(lineNumber: lineNumber, delay: delay, pointerAngle: pointer)
        setNeedsDisplay()
    }
}

