//
//  MapViewController.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 15/12/2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @Global var viewModel: MapViewModel
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    lazy var searchLineTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Podaj numer linii"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        return searchTextField
    }()
    
    lazy var toggleButtonsStackView: UIStackView = {
        let buttonHeight: CGFloat = 35
        let stackHeight: CGFloat = 50
        let cornerRadius: CGFloat = 12
        
        let backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        let spacerLeft = UIView()
        let spacerRight = UIView()
        
        let label = UILabel()
        label.text = "Pokaż pojazdy/przystanki"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = backgroundColor
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        let vehiclesButton = UIButton()
        vehiclesButton.configuration = .gray()
        vehiclesButton.addTarget(self, action: #selector(toggleVehicles), for: .touchUpInside)
        vehiclesButton.configuration?.image = UIImage(named: "bus")
        
        let stopsButton = UIButton()
        stopsButton.configuration = .gray()
        stopsButton.addTarget(self, action: #selector(toggleStops), for: .touchUpInside)
        stopsButton.configuration?.image = UIImage(named: "mappin")
        
        let ticketmachineButton = UIButton()
        ticketmachineButton.configuration = .gray()
        ticketmachineButton.configuration?.image = UIImage(named: "tickets")
        
        let stack = UIStackView(arrangedSubviews: [spacerLeft, label, vehiclesButton, stopsButton,ticketmachineButton, spacerRight])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: buttonHeight),
            vehiclesButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            stopsButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            ticketmachineButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            stack.heightAnchor.constraint(equalToConstant: stackHeight),
            
            spacerLeft.widthAnchor.constraint(equalToConstant: 2),
            spacerRight.widthAnchor.constraint(equalToConstant: 2)
        ])

        return stack
    }()

    private func addVehicleAnnotations() async throws {
        do {
            try await viewModel.addVehicleAnnotations(on: mapView)
            viewModel.updateVehiclesOnMapView(self.mapView, lineNumber: searchLineTextField.text!)
        } catch {
            throw error
        }
    }
    
    private func addRequestedAnnotations() async throws {
        do {
            try await viewModel.addVehicleAnnotations(on: mapView, lineNumber: searchLineTextField.text!)
            viewModel.updateVehiclesOnMapView(self.mapView, lineNumber: searchLineTextField.text!)
        } catch {
            throw error
        }
    }
    
    private func addStopAnnotations() async throws {
        do {
            try await viewModel.addStopAnnotations(on: mapView)
        } catch {
            throw error
        }
    }
    
    private func removeVehiclesFromMap() {
        mapView.removeAnnotations(mapView.annotations)
        viewModel.vehicleAnnotations.removeAll()
        viewModel.stopRequest()

    }
    
    private func removeStopsFromMap() {
        mapView.removeAnnotations(viewModel.stopAnnotations)
        viewModel.stopAnnotations.removeAll()
    }
    
    func updateMapView() {
        if viewModel.showVehicles {
            Task {
                do {
                    try await addVehicleAnnotations()
                } catch {
                    print("Błąd podczas dodawania pojazdów: \(error)")
                }
            }
        } else if viewModel.showRequestedLine {
            Task {
                do {
                    try await addRequestedAnnotations()
                } catch {
                    print("Błąd podczas dodawania pojazdu danej linii: \(error)")
                }
            }
        } else {
            removeVehiclesFromMap()
        }
        
        if viewModel.showStops {
            Task {
                do {
                    try await addStopAnnotations()
                } catch {
                    print("Błąd podczas dodawania przystanków: \(error)")
                }
            }
        } else{ removeStopsFromMap() }
    }

    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(searchLineTextField)
        view.addSubview(toggleButtonsStackView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchLineTextField.heightAnchor.constraint(equalToConstant: 40),
            searchLineTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchLineTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2),
            searchLineTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toggleButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toggleButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButtonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            toggleButtonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        toggleButtonsStackView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    }
    
    @objc private func toggleVehicles() {
        viewModel.showVehicles.toggle()
        updateMapView()
    }
    @objc private func toggleStops() {
        viewModel.showStops.toggle()
        updateMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.showVehicles {
            viewModel.updateVehiclesOnMapView(mapView, lineNumber: searchLineTextField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        searchLineTextField.delegate = self
        searchLineTextField.isEnabled = true
        searchLineTextField.isUserInteractionEnabled = true
        
        mapView.delegate = self
        mapView.register(CustomStopView.self,
        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        //location manager
        viewModel.locationManager = CLLocationManager()
        viewModel.locationManager?.delegate = self
        viewModel.locationManager?.requestWhenInUseAuthorization()
        viewModel.locationManager?.requestAlwaysAuthorization()
        viewModel.locationManager?.requestLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopRequest()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = viewModel.locationManager, let location = locationManager.location else {return}
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
                mapView.setRegion(region, animated: true)
            case .denied:
                print("Location services has been denied.")
            case .notDetermined, .restricted:
                print("Location cannot be determined.")
            @unknown default:
                print("Unknown. Unable to get location.")
        }
    }
}

