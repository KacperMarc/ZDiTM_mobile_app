//
//  LineInformationViewController.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 15/02/2025.
//

import UIKit
import MapKit

class LineInformationViewController: UIViewController {
    
    @Global var mapViewModel: MapViewModel
    private let model: LineInformationViewModel
    private let lineNumber: String
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    init(lineNumber: String, model: LineInformationViewModel) {
        self.model = model
        self.lineNumber = lineNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private lazy var lineLabel = InfoCardView(title: "Linia: \(lineNumber)", content: model.information?.type ?? "Brak rodzaju")
    
    private lazy var directionsLabel = InfoCardView(title: "Linia: \(lineNumber)", content: model.information?.type ?? "Brak rodzaju")
    
    private lazy var stopsStack = InfoCardView(title: "Przystanki na linii", content: "", viewComponent: returnStopsStack())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        Task {
            await model.prepareData()
            try await addRequestedAnnotations()
            setupUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapViewModel.stopRequest()
    }
    
    private func addRequestedAnnotations() async throws {
        do {
            try await mapViewModel.addVehicleAnnotations(on: mapView, lineNumber: lineNumber )
            mapViewModel.updateVehiclesOnMapView(mapView, lineNumber: lineNumber )
        }
        catch {
            print(error)
            throw error
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentStackView.addArrangedSubview(lineLabel)
        addComponents(on: contentStackView)
        contentStackView.addArrangedSubview(mapView)
        Task {
            try await mapViewModel.addRouteOnMap(on: mapView, of: model.number)
        }
        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor)
        ])
        mapView.layer.cornerRadius = 20
        mapView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    func addComponents(on stack: UIStackView) {
        stack.addArrangedSubview(self.directionsLabel)
        stack.addArrangedSubview(self.stopsStack)
    }
    
    private let labelPrzystankiNaLini: UILabel = {
       let label = UILabel()
        label.text = "Przystanki na linii"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private func returnStopLabel(stopName: String) -> UILabel {
        let label = UILabel()
        label.text = stopName
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        
        return label
    }
    
    func returnStopsTowards() -> [UILabel]{
        model.information?.stopsTowards.map { returnStopLabel(stopName: $0) } ?? []
    }
    
    func returnStopsBackwards() -> [UILabel]{
        model.information?.stopsBackwards.map { returnStopLabel(stopName: $0) } ?? []
    }

    private func returnStopsStack() -> UIStackView {
        let leftLabels = returnStopsTowards()
        let rightLabels = returnStopsBackwards()
        
        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.spacing = 10
        leftStackView.distribution = .fillEqually
        for label in leftLabels {
            leftStackView.addArrangedSubview(label)
        }

        let rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.spacing = 10
        rightStackView.distribution = .fillEqually
        for label in rightLabels {
            rightStackView.addArrangedSubview(label)
        }
        
        let stackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }
    
}

