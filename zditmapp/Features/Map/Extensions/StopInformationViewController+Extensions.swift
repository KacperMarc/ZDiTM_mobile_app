//
//  StopInformationViewController+Extensions.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 09/08/2025.
//
import UIKit


extension StopInformationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(viewModel.departureTable?.departures.count ?? 0, 5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartureCell", for: indexPath) as! DepartureTableViewCell
        
        if let departureTable = viewModel.departureTable, indexPath.row < departureTable.departures.count {
            let departure = departureTable.departures[indexPath.row]
            cell.configure(with: departure)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
