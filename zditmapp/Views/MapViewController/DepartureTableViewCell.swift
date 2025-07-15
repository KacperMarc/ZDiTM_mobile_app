//
//  DepartureTableViewCell.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 05/06/2025.
//
import UIKit

class DepartureTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let lineNumberLabel = UILabel()
    private let directionLabel = UILabel()
    private let timeLabel = UILabel()
    private let timeTypeIndicator = UIView()
    private let vehicleIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container view
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Vehicle icon
        vehicleIcon.tintColor = UIColor.systemBlue
        vehicleIcon.contentMode = .scaleAspectFit
        vehicleIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(vehicleIcon)
        
        // Line number label
        lineNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lineNumberLabel.textColor = .darkText
        lineNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lineNumberLabel)
        
        // Direction label
        directionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        directionLabel.textColor = .darkText
        directionLabel.numberOfLines = 1
        directionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(directionLabel)
        
        // Time type indicator
        timeTypeIndicator.layer.cornerRadius = 4
        timeTypeIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeTypeIndicator)
        
        // Time label
        timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Vehicle icon
            vehicleIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            vehicleIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            vehicleIcon.widthAnchor.constraint(equalToConstant: 24),
            vehicleIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Line number label
            lineNumberLabel.leadingAnchor.constraint(equalTo: vehicleIcon.trailingAnchor, constant: 12),
            lineNumberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            lineNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            // Direction label
            directionLabel.leadingAnchor.constraint(equalTo: lineNumberLabel.trailingAnchor, constant: 8),
            directionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            
            // Time type indicator
            timeTypeIndicator.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            timeTypeIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            timeTypeIndicator.widthAnchor.constraint(equalToConstant: 8),
            timeTypeIndicator.heightAnchor.constraint(equalToConstant: 8),
            
            // Time label
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 12)
        ])
    }
    
    func configure(with departure: DepartureInfo) {
        lineNumberLabel.text = departure.line_number
        directionLabel.text = "→ \(departure.direction)"
        
        // Configure time and indicator based on real-time vs scheduled
        if let realTime = departure.time_real {
            timeLabel.text = "\(realTime) min"
            timeLabel.textColor = .systemGreen
            timeTypeIndicator.backgroundColor = .systemGreen
        } else if let scheduledTime = departure.time_scheduled {
            timeLabel.text = scheduledTime
            timeLabel.textColor = .systemOrange
            timeTypeIndicator.backgroundColor = .systemOrange
        } else {
            timeLabel.text = "Brak danych"
            timeLabel.textColor = .systemGray
            timeTypeIndicator.backgroundColor = .systemGray
        }
        
        // Set vehicle icon based on line type (you can customize this based on your data)
        if let number = Int(departure.line_number), (1...12).contains(number) {
            vehicleIcon.image = UIImage(systemName: "tram.fill")
            vehicleIcon.tintColor = .black
        } else {
            vehicleIcon.image = UIImage(systemName: "bus.fill")
            vehicleIcon.tintColor = .black
        }

    }
}
