//
//  SearchConnectionViewController.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 15/12/2024.
//

import UIKit
import CoreData

class SearchConnectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView = UITableView()
    var filteredProducts: [Stops] = []
    var activeTextField: UITextField?
    var context: NSManagedObjectContext!
    
    lazy var OriginTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Skąd chcesz jechać"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 0.7
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.layer.masksToBounds = true
        
        return searchTextField
    }()
    
    lazy var DestinationTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Dokąd chcesz jechać"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 0.7
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.layer.masksToBounds = true
        
        return searchTextField
    }()
    
    lazy var SearchButton: UIButton = {
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("Wyszukaj", for: .normal)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.backgroundColor = UIColor(red: 30/255, green: 56/255, blue: 140/255, alpha: 1)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        return searchButton
    }()
    
    lazy var icon = VehicleWidget(line: "67", transportType: .bus(number: "67"), isWalk: false, meters: nil)
    
    lazy var StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [OriginTextField, DestinationTextField, icon ,SearchButton, tableView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(StackView)

        NSLayoutConstraint.activate([
            StackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            StackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            StackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            OriginTextField.heightAnchor.constraint(equalToConstant: 50),
            DestinationTextField.heightAnchor.constraint(equalToConstant: 50),
            SearchButton.heightAnchor.constraint(equalToConstant: 50),
            tableView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
        tableView.frame = CGRect(x: 20, y: 220, width: view.frame.width - 40, height: 200)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        setupUI()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text, !query.isEmpty else {
            tableView.isHidden = true
            return
        }
        fetchMatchingProducts(query: query)
    }
    
    func fetchMatchingProducts(query: String) {
        let request: NSFetchRequest<Stops> = Stops.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[c] %@", query)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            filteredProducts = try context.fetch(request)
            tableView.reloadData()
            tableView.isHidden = filteredProducts.isEmpty
        } catch {
            print("Błąd pobierania danych: \(error)")
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredProducts[indexPath.row].name
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        OriginTextField.text = filteredProducts[indexPath.row].name
        tableView.isHidden = true
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
            case OriginTextField:
                DestinationTextField.isHidden = true
                SearchButton.isHidden = true
            case DestinationTextField:
                OriginTextField.isHidden = true
                SearchButton.isHidden = true
            default:
                break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
        OriginTextField.isHidden = false
        DestinationTextField.isHidden = false
        SearchButton.isHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc private func handleSearch() {
        showConnections()
        Task{
            do {
                try await getConnections()
            } catch {
                print(error)
                throw error
            }
        }
    }
    
    private func getConnections() async throws {
        var routes: RouteResults = try await FetchingRoutes.fetchRoutes("public_transport", 53.44211, 14.574381, 53.466824, 14.536693, "2025-05-18T08:00:00Z", "f04bd349", "8335759bd98b2e0e2abe6105b32e5e91")
        print(routes)
    }
    
    private func showConnections(){
        let vc = ConnectionsResultViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.large()]
        }
        present(vc, animated: true)
    }
}
