//
//  VehicleInformationViewModel.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 29/12/2024.
//
import Foundation
import Combine

final class VehicleInformationViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    private let mapViewModel: MapViewModel
    private let vehicleId: Int
    
    //powinien zwracac i aktualizowac najwazniejsze dane a nie caly ciag stringow XD
    @Published private(set) var vehicleInformation: VehicleInformation? = VehicleInformation(
        lineInfo: "",
        stopInfo: "",
        punctualityInfo: "",
        vehicleDetails: "",
        vehicleType: "",
        ticketMachineInfo: "",
        vehicleImageName: "",
        vehicleTypeImageName: ""
    )
    init(vehicleId: Int, mapViewModel: MapViewModel){
        
        self.vehicleId = vehicleId
        self.mapViewModel = mapViewModel
        
        mapViewModel.$vehicleAnnotations
            .map { annotations in
                        annotations.first { $0.vehicle?.vehicle_id == vehicleId } // pierwsza gdzie id sie zgadza
                    }
                    .compactMap { $0 } 
                    .sink { [weak self] annotation in
                        self?.updateData(from: annotation)
                    }
                    .store(in: &cancellables)
                
    }
    
    
        
    func updateData(from annotation: CustomAnnotation) {
            guard let vehicle = annotation.vehicle else {
                vehicleInformation?.lineInfo = "Nieznana linia"
                
                vehicleInformation?.stopInfo = "Brak danych o przystankach"
                vehicleInformation?.punctualityInfo = "Brak danych o opóźnieniu"
                vehicleInformation?.vehicleDetails = "Brak danych o pojeździe"
                vehicleInformation?.vehicleType = "Brak danych o rodzaju"
                vehicleInformation?.ticketMachineInfo = "Brak danych o biletomacie"
                vehicleInformation?.vehicleImageName = "questionmark.circle.fill"
                vehicleInformation?.vehicleTypeImageName = ""
                return
            }
            vehicleInformation?.lineInfo = "\(vehicle.line_number) → \(vehicle.direction ?? "brak")"
            vehicleInformation?.stopInfo = "\(vehicle.previous_stop ?? "brak") → \(vehicle.next_stop ?? "brak")"
            vehicleInformation?.punctualityInfo = {
                if vehicle.punctuality > 0 {
                    return "Przyspieszenie: \(vehicle.punctuality) min"
                } else if vehicle.punctuality < 0 {
                    return "Opóźnienie: \(vehicle.punctuality) min"
                } else {
                    return "Na czas"
                }
            }()
            vehicleInformation?.vehicleDetails = "\(vehicle.vehicle_model ?? "Nieznany model") #\(vehicle.vehicle_number)"
            vehicleInformation?.vehicleType = {
                if vehicle.vehicle_low_floor! {
                    return "Niskopodłogowy"
                } else {
                    return "Wysokopodłogowy"
                }
            }()
            vehicleInformation?.ticketMachineInfo = {
                if vehicle.vehicle_ticket_machine!.cards && vehicle.vehicle_ticket_machine!.coins {
                    return "Biletomat na kartę i bilon"
                }
                if vehicle.vehicle_ticket_machine!.cards {
                    return "Biletomat karta"
                }
                if vehicle.vehicle_ticket_machine!.coins {
                    return "Biletomat bilon"
                }
                
                return "Brak biletomatu"
            }()
            vehicleInformation?.vehicleImageName = {
                switch vehicle.vehicle_type {
                case "bus":
                    return  "bus"
                case "tram":
                    return   "tram"
                default:
                    return "questionmark.circle.fill"
                }
            }()
            vehicleInformation?.vehicleTypeImageName = {
                if vehicle.vehicle_low_floor! {
                    return "wheelchair"
                }
                //własna ikonka z przekreślonym wózkiem XD
                return "wheelchair"
            }()
        }
        
        
    }

