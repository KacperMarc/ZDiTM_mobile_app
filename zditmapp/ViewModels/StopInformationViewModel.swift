//
//  StopInformationViewModel.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 01/01/2025.
//

import Foundation
import UIKit
import Combine

final class StopInformationViewModel: ObservableObject {
    
    
    
    private let tablesService = FetchingDepartureTables()
    @Published var departureTable: DepartureTable?
    let stopNumber: String
    
    init(stopNumber: String){
       
        self.stopNumber = stopNumber
        print("VM\(self.stopNumber)")
        Task {
            try await returnDepartureTable()
            

        }
    }
    //musi byc update'owany zeby przekazywany czas do odjazdu byl na biezaco odswiezany
    func returnDepartureTable() async throws {
        do{
            let departureTable = try await tablesService.getTable(number: stopNumber)
            DispatchQueue.main.async {
                self.departureTable = departureTable
            }
        }
        catch{
            print(error)
            throw error
        }
        
        
    }
    
}
