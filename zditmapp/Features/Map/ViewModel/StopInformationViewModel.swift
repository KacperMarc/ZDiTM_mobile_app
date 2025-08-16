//
//  StopInformationViewModel.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 01/01/2025.
//

import Foundation
import UIKit
import Combine

class StopInformationViewModel: ObservableObject {
    
    private let apiClient = APIClient()
    let stopNumber: String
    @Published var departureTable: DepartureTable?
    
    init(stopNumber: String){
        self.stopNumber = stopNumber
        print("VM\(self.stopNumber)")
        Task {
            try await returnDepartureTable()
        }
    }
    
    func returnDepartureTable() async throws {
        do{
            let departureTable = try await apiClient.getDepartureTable(number: stopNumber)
            DispatchQueue.main.async {
                self.departureTable = departureTable
            }
        }
        catch{
            print(error)
            throw error
        }
    }
    // MARK: - data binding required
}
