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
     private var headerLabel: UILabel!
     private var cardView: UIView!
     private var infoStackView: UIStackView!
     
     //make a tab
     private var lineRow: InfoRowView!
     private var currentStopRow: InfoRowView!
     private var delayRow: InfoRowView!
     private var vehicleRow: InfoRowView!
     private var vehicleTypeRow: InfoRowView!
     private var ticketMachineRow: InfoRowView!
     
     init(viewModel: VehicleInformationViewModel) {
         self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
         setupConstraints()
         dataBinding()
     }
     
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
         
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         contentView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(scrollView)
         scrollView.addSubview(contentView)
         
         headerLabel = UILabel()
         headerLabel.text = "Informacje o pojeździe"
         headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
         headerLabel.textColor = .darkText
         headerLabel.textAlignment = .center
         headerLabel.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(headerLabel)
         
         cardView = UIView()
         cardView.backgroundColor = .white
         cardView.layer.cornerRadius = 16
         cardView.layer.shadowColor = UIColor.black.cgColor
         cardView.layer.shadowOpacity = 0.1
         cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
         cardView.layer.shadowRadius = 10
         cardView.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(cardView)
         
         lineRow = createInfoRow(iconName: "line", title: "Linia", tintColor: UIColor.systemBlue)
         currentStopRow = createInfoRow(iconName: "mappin", title: "Aktualny przystanek", tintColor: UIColor.systemGreen)
         delayRow = createInfoRow(iconName: "clock", title: "Punktualność", tintColor: UIColor.systemOrange)
         vehicleRow = createInfoRow(iconName: viewModel.vehicleInformation!.vehicleImageName, title: "Pojazd", tintColor: UIColor.systemPurple)
         vehicleTypeRow = createInfoRow(iconName: viewModel.vehicleInformation!.vehicleTypeImageName, title: "Rodzaj", tintColor: UIColor.systemIndigo)
         ticketMachineRow = createInfoRow(iconName: "tickets", title: "Biletomat", tintColor: UIColor.systemTeal)
         
         infoStackView = UIStackView(arrangedSubviews: [
             lineRow,
             currentStopRow,
             delayRow,
             vehicleRow,
             vehicleTypeRow,
             ticketMachineRow
         ])
         
         infoStackView.axis = .vertical
         infoStackView.spacing = 16
         infoStackView.distribution = .fill
         infoStackView.alignment = .fill
         infoStackView.translatesAutoresizingMaskIntoConstraints = false
         cardView.addSubview(infoStackView)
         
         let featuresLabel = UILabel()
         featuresLabel.text = "Udogodnienia"
         featuresLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
         featuresLabel.textColor = .darkText
         featuresLabel.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(featuresLabel)
         
         let featuresContainer = UIView()
         featuresContainer.backgroundColor = .white
         featuresContainer.layer.cornerRadius = 12
         featuresContainer.layer.shadowColor = UIColor.black.cgColor
         featuresContainer.layer.shadowOpacity = 0.08
         featuresContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
         featuresContainer.layer.shadowRadius = 6
         featuresContainer.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(featuresContainer)
         
         // there is a change in viewModel required which will return line id and its name to avoid filtering strings
         let showRoute = createFeatureButton(iconName: "mappin.and.ellipse", title: "Pojazdy tej linii")
         let showLineVehicles = createFeatureButton(iconName: "route", title: "Trasa przejazdu")
         
         let featuresStack = UIStackView(arrangedSubviews: [showRoute, showLineVehicles])
         featuresStack.axis = .horizontal
         featuresStack.distribution = .fillEqually
         featuresStack.spacing = 12
         featuresStack.translatesAutoresizingMaskIntoConstraints = false
         featuresContainer.addSubview(featuresStack)
         
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
             scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             
             contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
             contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
             contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
             contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
             contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
             
             headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
             headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
             headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
             
             cardView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
             cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
             cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
             
             infoStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
             infoStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
             infoStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
             infoStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
         ])
     }
     
     // helpers
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
         print("Inne linie")
     }

     private func dataBinding(){
         viewModel.$vehicleInformation
             .receive(on: DispatchQueue.main)
             .sink { [weak self] vehicleInformation in
                 guard let vehicleInformation = vehicleInformation else { return }
                 //labels
                 self?.lineRow.valueLabel.text = vehicleInformation.lineInfo
                 self?.currentStopRow.valueLabel.text = vehicleInformation.stopInfo
                 self?.delayRow.valueLabel.text = vehicleInformation.punctualityInfo
                 self?.vehicleRow.valueLabel.text = vehicleInformation.vehicleDetails
                 self?.vehicleTypeRow.valueLabel.text = vehicleInformation.vehicleType
                 self?.ticketMachineRow.valueLabel.text = vehicleInformation.ticketMachineInfo
                 //delay color
                 switch true {
                     case vehicleInformation.punctualityInfo.contains("Na czas"):
                         self?.delayRow.valueLabel.textColor = .systemGreen
                     case vehicleInformation.punctualityInfo.contains("Przyspieszenie"):
                         self?.delayRow.valueLabel.textColor = .systemBlue
                     case vehicleInformation.punctualityInfo.contains("Opóźnienie"):
                         self?.delayRow.valueLabel.textColor = .systemRed
                     default:
                         self?.delayRow.valueLabel.textColor = .systemBlue
                 }
             }
             .store(in: &cancellables)
     }
 }


 
