 //
 //  VehicleInformation.swift
 //  zditmapp
 //
 //  Created by Kacper Marciszewski on 01/06/2025.
 //

 import UIKit
 import Combine

 class VehicleInformationViewController: UIViewController {
     
     private let viewModel: VehicleInformationViewModel
     private var cancellables: Set<AnyCancellable> = []
     private let scrollView = UIScrollView()
     private let contentView = UIView()
     
     // MARK: - UI Components
     private var headerLabel: UILabel!
     private var cardView: UIView!
     private var infoStackView: UIStackView!
     
     // Info components
     private var liniaView: InfoRowView!
     private var aktualnyPrzystanekView: InfoRowView!
     private var opoznienieView: InfoRowView!
     private var pojazdView: InfoRowView!
     private var rodzajView: InfoRowView!
     private var biletomatView: InfoRowView!
     
     // MARK: - Initialization
     init(viewModel: VehicleInformationViewModel) {
         self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     // MARK: - Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
         setupConstraints()
         dataBinding()
     }
     
     // MARK: - UI Setup
     private func createFeatureButton(iconName: String, title: String?) -> UIButton {
         let button = UIButton(type: .system)
         button.addTarget(self, action: #selector(showOtherLineVehicles), for: .touchUpInside)
         
         var config = UIButton.Configuration.filled()
         config.baseBackgroundColor = .systemGray6
         config.image = UIImage(named: iconName)
         config.title = title
         config.imagePlacement = .top
         config.imagePadding = 8
         config.baseForegroundColor = .black
         config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

         button.configuration = config
         
         return button
     }
     
     private func setupUI() {
         view.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
         
         // Setup scroll view
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         contentView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(scrollView)
         scrollView.addSubview(contentView)
         
         // Header
         headerLabel = UILabel()
         headerLabel.text = "Informacje o pojeździe"
         headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
         headerLabel.textColor = .darkText
         headerLabel.textAlignment = .center
         headerLabel.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(headerLabel)
         
         // Card view
         cardView = UIView()
         cardView.backgroundColor = .white
         cardView.layer.cornerRadius = 16
         cardView.layer.shadowColor = UIColor.black.cgColor
         cardView.layer.shadowOpacity = 0.1
         cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
         cardView.layer.shadowRadius = 10
         cardView.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(cardView)
         
         // Info rows
         liniaView = createInfoRow(iconName: "line", title: "Linia", tintColor: UIColor.systemBlue)
         aktualnyPrzystanekView = createInfoRow(iconName: "mappin", title: "Aktualny przystanek", tintColor: UIColor.systemGreen)
         opoznienieView = createInfoRow(iconName: "clock", title: "Punktualność", tintColor: UIColor.systemOrange)
         pojazdView = createInfoRow(iconName: viewModel.vehicleInformation!.vehicleImageName, title: "Pojazd", tintColor: UIColor.systemPurple)
         rodzajView = createInfoRow(iconName: viewModel.vehicleInformation!.vehicleTypeImageName, title: "Rodzaj", tintColor: UIColor.systemIndigo)
         biletomatView = createInfoRow(iconName: "tickets", title: "Biletomat", tintColor: UIColor.systemTeal)
         
         // Stack view for info rows
         infoStackView = UIStackView(arrangedSubviews: [
             liniaView,
             aktualnyPrzystanekView,
             opoznienieView,
             pojazdView,
             rodzajView,
             biletomatView
         ])
         infoStackView.axis = .vertical
         infoStackView.spacing = 16
         infoStackView.distribution = .fill
         infoStackView.alignment = .fill
         infoStackView.translatesAutoresizingMaskIntoConstraints = false
         cardView.addSubview(infoStackView)
         
         // Additional features section
         let featuresLabel = UILabel()
         featuresLabel.text = "Udogodnienia"
         featuresLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
         featuresLabel.textColor = .darkText
         featuresLabel.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(featuresLabel)
         
         // Features container
         let featuresContainer = UIView()
         featuresContainer.backgroundColor = .white
         featuresContainer.layer.cornerRadius = 12
         featuresContainer.layer.shadowColor = UIColor.black.cgColor
         featuresContainer.layer.shadowOpacity = 0.08
         featuresContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
         featuresContainer.layer.shadowRadius = 6
         featuresContainer.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(featuresContainer)
         
         // Features stack - dwa przyciski z trajektoria tej linii i pojazdami
         
         
         // będzie potrzebna zmiana w viewmodel żeby zwracała tylko id linii i jej nazwę żeby nie filtrować po stringach bo potem ta linia wyświetli tylko jej pojazdy
         let showRoute = createFeatureButton(iconName: "mappin.and.ellipse", title: "Pojazdy tej linii")
         let showLineVehicles = createFeatureButton(iconName: "trasa", title: "Trasa przejazdu")
         
         
         
         let featuresStack = UIStackView(arrangedSubviews: [showRoute, showLineVehicles])
         featuresStack.axis = .horizontal
         featuresStack.distribution = .fillEqually
         featuresStack.spacing = 12
         featuresStack.translatesAutoresizingMaskIntoConstraints = false
         featuresContainer.addSubview(featuresStack)
         
         // Constraints for features
         NSLayoutConstraint.activate([
             featuresLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
             featuresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
             
             featuresContainer.topAnchor.constraint(equalTo: featuresLabel.bottomAnchor, constant: 12),
             featuresContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
             featuresContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
             featuresContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
             
             featuresStack.topAnchor.constraint(equalTo: featuresContainer.topAnchor, constant: 16),
             featuresStack.leadingAnchor.constraint(equalTo: featuresContainer.leadingAnchor, constant: 16),
             featuresStack.trailingAnchor.constraint(equalTo: featuresContainer.trailingAnchor, constant: -16),
             featuresStack.bottomAnchor.constraint(equalTo: featuresContainer.bottomAnchor, constant: -16)
         ])
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
             
             // Header constraints
             headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
             headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
             headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
             
             // Card view constraints
             cardView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
             cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
             cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
             
             // Info stack view constraints
             infoStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
             infoStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
             infoStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
             infoStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
         ])
     }
     
     // MARK: - Helper Methods
     private func createInfoRow(iconName: String, title: String, tintColor: UIColor) -> InfoRowView {
         let infoRow = InfoRowView()
         infoRow.configure(iconName: iconName, title: title, tintColor: tintColor)
         return infoRow
     }
     
     
     private func createFeatureView(iconName: String, title: String) -> UIView {
         let container = UIView()
         
         let iconView = UIImageView()
         iconView.image = UIImage(named: iconName)
         iconView.contentMode = .scaleAspectFit
         iconView.tintColor = UIColor.systemBlue
         iconView.translatesAutoresizingMaskIntoConstraints = false
         
         let label = UILabel()
         label.text = title
         label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
         label.textColor = .darkGray
         label.textAlignment = .center
         label.numberOfLines = 2
         label.translatesAutoresizingMaskIntoConstraints = false
         
         container.addSubview(iconView)
         container.addSubview(label)
         
         NSLayoutConstraint.activate([
             iconView.topAnchor.constraint(equalTo: container.topAnchor),
             iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
             iconView.widthAnchor.constraint(equalToConstant: 28),
             iconView.heightAnchor.constraint(equalToConstant: 28),
             
             label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
             label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
             label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
             label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
         ])
         
         return container
     }
     
     @objc private func showOtherLineVehicles(){
         print("jebac kurwy")
     }
     
     // MARK: - Data Binding
     private func dataBinding(){
         viewModel.$vehicleInformation
             .receive(on: DispatchQueue.main)
             .sink { [weak self] vehicleInformation in
                 guard let vehicleInformation = vehicleInformation else {return}
                 //labels
                 //print(vehicleInformation.lineInfo)
                 self?.liniaView.valueLabel.text = vehicleInformation.lineInfo
                 self?.aktualnyPrzystanekView.valueLabel.text = vehicleInformation.stopInfo
                 self?.opoznienieView.valueLabel.text = vehicleInformation.punctualityInfo
                 self?.pojazdView.valueLabel.text = vehicleInformation.vehicleDetails
                 self?.rodzajView.valueLabel.text = vehicleInformation.vehicleType
                 self?.biletomatView.valueLabel.text = vehicleInformation.ticketMachineInfo
                 //delay color
                 switch true {
                     case vehicleInformation.punctualityInfo.contains("Na czas"):
                         self?.opoznienieView.valueLabel.textColor = .systemGreen
                     case vehicleInformation.punctualityInfo.contains("Przyspieszenie"):
                         self?.opoznienieView.valueLabel.textColor = .systemBlue
                     case vehicleInformation.punctualityInfo.contains("Opóźnienie"):
                         self?.opoznienieView.valueLabel.textColor = .systemRed
                     default:
                         self?.opoznienieView.valueLabel.textColor = .systemBlue
                 }
                 //self?.pojazdImage.image = UIImage(named: vehicleInformation.vehicleImageName)
                 //self?.rodzajImage.image = UIImage(named: vehicleInformation.vehicleTypeImageName)
                 
                 
             }
             .store(in: &cancellables)
     }
 }


 
