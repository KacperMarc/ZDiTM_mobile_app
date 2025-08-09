//
//  InfoCardView.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 14/06/2025.
//
import UIKit

class InfoCardView: UIView {
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let containerView = UIView()
    private var viewComponent: UIView?
    //bool parameter to decide whether create content section or not
    
    init(title: String, content: String?, viewComponent: UIView? = nil){
        super.init(frame: .zero)
        self.viewComponent = viewComponent
        setupUI(title: title, content: content ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String, content: String){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        addSubview(containerView)

        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentLabel.text = content
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)

        if let component = viewComponent {
            component.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(component)

            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

                component.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
                component.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                component.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                component.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
        }
    }
}
