//
//  InfoRowView.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 04/06/2025.
//
import UIKit

class InfoRowView: UIView {
    lazy var iconContainer = UIView()
    lazy var iconImageView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var valueLabel = UILabel()
    lazy var divider = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Icon container
        iconContainer.backgroundColor = UIColor.systemGray6
        iconContainer.layer.cornerRadius = 20
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconContainer)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(iconImageView)
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .gray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Value label
        valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = .darkText
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        // Divider
        divider.backgroundColor = UIColor.systemGray5
        divider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            // Icon container constraints
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainer.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon constraints
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Value label constraints
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Divider constraints
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 12)
        ])
    }
    
    func configure(iconName: String, title: String, tintColor: UIColor) {
        iconImageView.image = UIImage(named: iconName)
        iconImageView.tintColor = tintColor
        titleLabel.text = title
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
    
    func setValueColor(_ color: UIColor) {
        valueLabel.textColor = color
    }
}



