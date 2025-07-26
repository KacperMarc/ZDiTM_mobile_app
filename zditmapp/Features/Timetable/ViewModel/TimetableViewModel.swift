//
//  TimetableViewModel.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 24/12/2024.
//

import Foundation
import UIKit

class TimetableViewModel: ObservableObject {
    private let service = FetchingLines()
    @Published var mappedLines: [String: [Line]] = [:]


    func addSection(on view: UIStackView, onButtonTap: @escaping (String, Int) -> Void) async {
        print("called addSection")

        await returnMappedLines {}
        DispatchQueue.main.async {
            for (category, lines) in self.mappedLines {
                let sectionView = self.createSection(title: category, lines: lines, onButtonTap: onButtonTap)
                view.addArrangedSubview(sectionView)
            }
        }
        
    }
    func returnMappedLines(completion: @escaping () -> Void) async {
        do {
            let lines = try await service.getData()
            print("calledFetch")

            DispatchQueue.main.async {
                self.mappedLines = [
                    "Tramwaje": lines.filter {
                                if let number = Int($0.number) {
                                    return (1...11).contains(number)
                                }
                                return false
                            },
                    "Autobusy": lines.filter {
                                if let number = Int($0.number) {
                                    return (51...244).contains(number)
                                }
                                return false
                            },
                    "Autobusy nż": lines.filter {
                                if let number = Int($0.number) {
                                    return (904...909).contains(number)
                                }
                                return false
                            },
                    "Autobusy pospieszne" : lines.filter {
                        let busLetters: Set<String> = ["A", "B", "C", "D", "E", "F"]
                        return busLetters.contains($0.number)
                    },
                    "Autobusy nocne": lines.filter {
                                if let number = Int($0.number) {
                                    return (521...536).contains(number)
                                }
                                return false
                            }
                ]
                
                completion()
            }
        } catch {
            print("Błąd podczas pobierania danych: \(error)")
        }
    }
    //
    private func createSection(title: String, lines: [Line], onButtonTap: @escaping (String, Int) -> Void) -> UIStackView {
        let sectionLabel = createLabel(text: title, fontSize: 18, weight: .medium)
        
        let sectionButtons = createGridStackView(lines: lines, buttonColor: .green, onButtonTap: onButtonTap)

        let stackView = UIStackView(arrangedSubviews: [sectionLabel, sectionButtons])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }
    

    private func createGridStackView(lines: [Line], buttonColor: UIColor, onButtonTap: @escaping (String, Int) -> Void) -> UIStackView {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        var rowStackView = createRowStackView()
        var buttonsInRow = 0

        for line in lines {
            let button = createButton(title: line.number, id: line.id, onButtonTap: onButtonTap)
            rowStackView.addArrangedSubview(button)
            buttonsInRow += 1

                if buttonsInRow == 7 {
                    mainStackView.addArrangedSubview(rowStackView)
                    rowStackView = createRowStackView()
                    buttonsInRow = 0
                }
            }

            if buttonsInRow > 0 {
                let remainingSpaces = 7 - buttonsInRow
                for _ in 0..<remainingSpaces {
                    rowStackView.addArrangedSubview(UIView())
                }
                mainStackView.addArrangedSubview(rowStackView)
            }

        return mainStackView
    }
    
    private func createButton(title: String, id: Int, onButtonTap: @escaping (String, Int) -> Void) -> UIButton {
        
        var buttonColor: UIColor {
            if let titleIsNumber = Int(title) {
                switch titleIsNumber {
                    case 1...12:
                        return UIColor(red: 0/255, green: 159/255, blue: 227/255, alpha: 1)
                    case 51...244:
                        return UIColor(red: 130/255, green: 188/255, blue: 0/255, alpha: 1)
                    case 904...909:
                        return UIColor(red: 130/255, green: 188/255, blue: 0/255, alpha: 1)
                    
                    case 521...536:
                        return .black
                    
                    default:
                        return .systemGray
                }
            }else {
                switch title.uppercased() {
                case "A", "B", "C":
                    return UIColor(red: 227/255, green: 6/255, blue: 19/255, alpha: 1)
                default :
                    return .gray
                }
            }
        }
        
        
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        button.addAction(UIAction { _ in onButtonTap(title, id) }, for: .touchUpInside)
        
        return button
    }

    private func createRowStackView() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 8
        rowStackView.alignment = .fill
        rowStackView.distribution = .fillEqually
        return rowStackView
    }

    private func createLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = .black
        return label
    }
    
}
