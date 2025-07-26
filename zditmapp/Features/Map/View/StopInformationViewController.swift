import UIKit
import Combine

class StopInformationViewController: UIViewController {
    
    private var viewModel: StopInformationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerCard = UIView()
    private let departuresCard = UIView()
    private let tableView = UITableView()
    
    // Header components
    private var stopNameLabel: UILabel!
    private var stopNumberLabel: UILabel!
    private var lastUpdateLabel: UILabel!
    private var refreshButton: UIButton!
    
    // Departures section
    private var departuresHeaderLabel: UILabel!
    private var noDeparturesLabel: UILabel!
    private var errorLabel: UILabel!
    private var loadingIndicator: UIActivityIndicatorView!
    private var messageLabel: UILabel!
    
    // State tracking
    private var isLoading = false {
        didSet {
            updateLoadingState()
        }
    }
    
    init(viewModel: StopInformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("VC\(viewModel.stopNumber)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        dataBinding()
        
        isLoading = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Setup header card
        setupHeaderCard()
        
        // Setup departures card
        setupDeparturesCard()
    }
    
    private func setupHeaderCard() {
        headerCard.backgroundColor = .white
        headerCard.layer.cornerRadius = 16
        headerCard.layer.shadowColor = UIColor.black.cgColor
        headerCard.layer.shadowOpacity = 0.1
        headerCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerCard.layer.shadowRadius = 10
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerCard)
        
        // Stop icon
        let stopIcon = UIImageView()
        stopIcon.image = UIImage(systemName: "bus.fill")
        stopIcon.tintColor = UIColor.systemBlue
        stopIcon.contentMode = .scaleAspectFit
        stopIcon.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(stopIcon)
        
        // Stop name label
        stopNameLabel = UILabel()
        stopNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        stopNameLabel.textColor = .darkText
        stopNameLabel.numberOfLines = 0
        stopNameLabel.text = "Ładowanie..."
        stopNameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(stopNameLabel)
        
        // Stop number label
        stopNumberLabel = UILabel()
        stopNumberLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        stopNumberLabel.textColor = .systemGray
        stopNumberLabel.text = "Przystanek \(viewModel.stopNumber)"
        stopNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(stopNumberLabel)
        
        // Last update label
        lastUpdateLabel = UILabel()
        lastUpdateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lastUpdateLabel.textColor = .systemGray2
        //lastUpdateLabel.text = "Ładowanie danych..."
        lastUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(lastUpdateLabel)
        
        // Refresh button
        refreshButton = UIButton(type: .system)
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = UIColor.systemBlue
        refreshButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        refreshButton.layer.cornerRadius = 20
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
       // headerCard.addSubview(refreshButton)
        
        // Header constraints
        NSLayoutConstraint.activate([
            stopIcon.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            stopIcon.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 20),
            stopIcon.widthAnchor.constraint(equalToConstant: 32),
            stopIcon.heightAnchor.constraint(equalToConstant: 32),
            
            stopNameLabel.leadingAnchor.constraint(equalTo: stopIcon.trailingAnchor, constant: 16),
            stopNameLabel.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 20),
            //stopNameLabel.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: -16),
            
            stopNumberLabel.leadingAnchor.constraint(equalTo: stopNameLabel.leadingAnchor),
            stopNumberLabel.topAnchor.constraint(equalTo: stopNameLabel.bottomAnchor, constant: 4),
            stopNumberLabel.trailingAnchor.constraint(equalTo: stopNameLabel.trailingAnchor),
            
            lastUpdateLabel.leadingAnchor.constraint(equalTo: stopNameLabel.leadingAnchor),
            lastUpdateLabel.topAnchor.constraint(equalTo: stopNumberLabel.bottomAnchor, constant: 8),
            lastUpdateLabel.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -20),
            
           // refreshButton.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20),
           // refreshButton.centerYAnchor.constraint(equalTo: headerCard.centerYAnchor),
           // refreshButton.widthAnchor.constraint(equalToConstant: 40),
           // refreshButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupDeparturesCard() {
        departuresCard.backgroundColor = .white
        departuresCard.layer.cornerRadius = 16
        departuresCard.layer.shadowColor = UIColor.black.cgColor
        departuresCard.layer.shadowOpacity = 0.1
        departuresCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        departuresCard.layer.shadowRadius = 10
        departuresCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(departuresCard)
        
        // Departures header
        departuresHeaderLabel = UILabel()
        departuresHeaderLabel.text = "Najbliższe odjazdy"
        departuresHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        departuresHeaderLabel.textColor = .darkText
        departuresHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        departuresCard.addSubview(departuresHeaderLabel)
        
        // Schedule info label
        let scheduleInfoLabel = UILabel()
        scheduleInfoLabel.text = "według rozkładu jazdy"
        scheduleInfoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        scheduleInfoLabel.textColor = .systemGray
        scheduleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        departuresCard.addSubview(scheduleInfoLabel)
        
        // Message label (for API messages)
        messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        messageLabel.textColor = .systemOrange
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        departuresCard.addSubview(messageLabel)
        
        // Loading indicator
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        departuresCard.addSubview(loadingIndicator)
        
        // No departures label
        noDeparturesLabel = UILabel()
        noDeparturesLabel.text = "Brak dostępnych odjazdów"
        noDeparturesLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        noDeparturesLabel.textColor = .systemGray
        noDeparturesLabel.textAlignment = .center
        noDeparturesLabel.isHidden = true
        noDeparturesLabel.translatesAutoresizingMaskIntoConstraints = false
        departuresCard.addSubview(noDeparturesLabel)
        
        // Error label
        errorLabel = UILabel()
        errorLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        departuresCard.addSubview(errorLabel)
        
        // Table view setup
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        departuresCard.addSubview(tableView)
        
        // Departures card constraints
        NSLayoutConstraint.activate([
            departuresHeaderLabel.topAnchor.constraint(equalTo: departuresCard.topAnchor, constant: 20),
            departuresHeaderLabel.leadingAnchor.constraint(equalTo: departuresCard.leadingAnchor, constant: 20),
            
            scheduleInfoLabel.leadingAnchor.constraint(equalTo: departuresHeaderLabel.leadingAnchor),
            scheduleInfoLabel.topAnchor.constraint(equalTo: departuresHeaderLabel.bottomAnchor, constant: 2),
            
            messageLabel.centerXAnchor.constraint(equalTo: departuresCard.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: departuresCard.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: departuresCard.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: scheduleInfoLabel.bottomAnchor, constant: 12),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: departuresCard.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: scheduleInfoLabel.bottomAnchor, constant: 40),
            loadingIndicator.bottomAnchor.constraint(equalTo: departuresCard.bottomAnchor, constant: -40),
            
            noDeparturesLabel.centerXAnchor.constraint(equalTo: departuresCard.centerXAnchor),
            noDeparturesLabel.topAnchor.constraint(equalTo: scheduleInfoLabel.bottomAnchor, constant: 40),
            noDeparturesLabel.bottomAnchor.constraint(equalTo: departuresCard.bottomAnchor, constant: -40),
            
            errorLabel.centerXAnchor.constraint(equalTo: departuresCard.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: departuresCard.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: departuresCard.trailingAnchor, constant: -20),
            errorLabel.topAnchor.constraint(equalTo: scheduleInfoLabel.bottomAnchor, constant: 40),
            errorLabel.bottomAnchor.constraint(equalTo: departuresCard.bottomAnchor, constant: -40),
            
            tableView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: departuresCard.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: departuresCard.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: departuresCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DepartureTableViewCell.self, forCellReuseIdentifier: "DepartureCell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header card constraints
            headerCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Departures card constraints
            departuresCard.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 16),
            departuresCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            departuresCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            departuresCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Loading State Management
    private func updateLoadingState() {
        DispatchQueue.main.async {
            if self.isLoading {
                self.loadingIndicator.startAnimating()
                self.loadingIndicator.isHidden = false
                self.tableView.isHidden = true
                self.noDeparturesLabel.isHidden = true
                self.errorLabel.isHidden = true
                self.messageLabel.isHidden = true
                self.refreshButton.isEnabled = false
            } else {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.refreshButton.isEnabled = true
            }
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = "Błąd: \(message)\n\nSpróbuj ponownie później"
            self.errorLabel.isHidden = false
            self.tableView.isHidden = true
            self.noDeparturesLabel.isHidden = true
            self.messageLabel.isHidden = true
            self.isLoading = false
        }
    }
    
    // MARK: - Actions
    @objc private func refreshTapped() {
        guard !isLoading else { return }
        
        // Add refresh animation
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 1.0
        refreshButton.layer.add(rotation, forKey: "rotationAnimation")
        
        // Start loading
        isLoading = true
        
        // Call your async method
        Task {
            do {
                try await viewModel.returnDepartureTable()
            } catch {
                showError(error.localizedDescription)
            }
        }
    }
    
    private func formatUpdateTime(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.timeStyle = .short
            displayFormatter.dateStyle = .none
            return "Ostatnia aktualizacja: \(displayFormatter.string(from: date))"
        } else {
            return "Ostatnia aktualizacja: \(dateString)"
        }
    }
    
    // MARK: - Data Binding
    private func dataBinding() {
        viewModel.$departureTable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] departureTable in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if let departureTable = departureTable {
                    self.stopNameLabel.text = departureTable.stop_name
                    self.stopNumberLabel.text = "Przystanek \(departureTable.stop_number)"
                    
                    if let message = departureTable.message, !message.isEmpty {
                        self.messageLabel.text = message
                        self.messageLabel.isHidden = false
                    } else {
                        self.messageLabel.isHidden = true
                    }
                    
                    let hasDepartures = !departureTable.departures.isEmpty
                    self.noDeparturesLabel.isHidden = hasDepartures
                    self.tableView.isHidden = !hasDepartures
                    self.errorLabel.isHidden = true
                    
                    if hasDepartures {
                        self.tableView.reloadData()
                        let rowCount = min(departureTable.departures.count, 5)
                        let tableHeight = CGFloat(rowCount * 70) //
                        
                        self.tableView.constraints.forEach { constraint in
                            if constraint.firstAttribute == .height {
                                constraint.isActive = false
                            }
                        }
                        
                        self.tableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
                    }
                } else {
                    self.stopNameLabel.text = "Brak danych"
                    self.noDeparturesLabel.isHidden = false
                    self.tableView.isHidden = true
                    self.errorLabel.isHidden = true
                    self.messageLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
}

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
