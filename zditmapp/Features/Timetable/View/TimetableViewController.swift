//
//  TimetableViewController.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 15/12/2024.
//

import UIKit

class TimetableViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let viewModel = TimetableViewModel()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Rozkład jazdy według linii"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        setupUI()
    }
    
    private func addComponents() {
        Task {
            do {
                await viewModel.addSection(on: contentStackView, onButtonTap: {[weak self] (lineNumber, lineId) in self?.goToLineDetails(lineNumber: lineNumber, lineId: lineId)})
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = label
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func goToLineDetails(lineNumber: String, lineId: Int) {
        let vm = LineInformationViewModel(number: lineId)
        let vc = LineInformationViewController(lineNumber: lineNumber, model: vm)
            vc.title = "Informacje o linii"
            navigationController?.pushViewController(vc, animated: true)
    }
}
