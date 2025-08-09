//
//  ClusterAnnotationView.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 16/01/2025.
//
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset to better align with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let cluster = annotation as? MKClusterAnnotation else {
            return
        }
        
        let customStopCount = cluster.memberAnnotations.filter { $0 is CustomStop }.count
        
        image = drawCluster(count: customStopCount)
    }
    
    private func drawCluster(count: Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 80, height: 80))
        return renderer.image { context in
            let cgContext = context.cgContext
            
            let center = CGPoint(x: 40, y: 40)
            let radius: CGFloat = 35
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            let greenColors: [CGColor] = [
                UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1).cgColor,
                UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 0.6).cgColor,
                UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2).cgColor,
                UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0).cgColor
            ]
            
            let yellowColors: [CGColor] = [
                UIColor(red: 0.5, green: 0.4, blue: 0.0, alpha: 1).cgColor,
                UIColor(red: 0.8, green: 0.7, blue: 0.0, alpha: 0.6).cgColor,
                UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.2).cgColor,
                UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0).cgColor
            ]
            
            let orangeColors: [CGColor] = [
                UIColor(red: 0.6, green: 0.2, blue: 0.0, alpha: 1).cgColor,
                UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.6).cgColor,
                UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 0.2).cgColor,
                UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 0).cgColor
            ]
            let selectedColors: [CGColor]
            switch count {
                case 1...9:
                    selectedColors = greenColors
                case 10...99:
                    selectedColors = yellowColors
                default:
                    selectedColors = orangeColors
            }
            let locations: [CGFloat] = [0.0, 0.5, 0.8, 1.0]
            
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: selectedColors as CFArray, locations: locations) {
                cgContext.drawRadialGradient(
                    gradient,
                    startCenter: center, startRadius: 0,
                    endCenter: center, endRadius: radius,
                    options: .drawsAfterEndLocation
                )
            }
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.darkGray,
                .font: UIFont.boldSystemFont(ofSize: 16)
            ]
            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}


