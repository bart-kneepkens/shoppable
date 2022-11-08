//
//  ProductCollectionViewCell.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    var product: Product? {
        didSet {
            nameLabel.text = product?.name
            
            if let subtitle = subtitle {
                subtitleLabel.text = subtitle
            }
            
            if let urlString = product?.imageUrl, let imageURL = URL(string: urlString) {
                UIImage.loadFromURL(imageURL) { [imageView] result in
                    DispatchQueue.main.async {
                        if case .success(let wrapped) = result {
                            imageView.image = wrapped
                        }
                    }
                }
            }
        }
    }
    
    var viewModel: ProductCollectionViewCellViewModel?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .contactAdd) // I'm only using .contactAdd to easily get a simple 'add' button.
        button.addTarget(self, action: #selector(addButtonTapped), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var subtitle: String? {
        guard let product = product else { return nil }
        
        var subtitle: String = "\(product.info.color)"
        
        switch product.type {
        case .couch:
            if let numberOfSeats = product.info.numberOfSeats {
                subtitle.append(" - \(numberOfSeats) seats")
            }
        case .chair:
            if let material = product.info.material {
                subtitle.append(" - \(material)")
            }
        }
        
        return subtitle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant:  0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])   
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc private func addButtonTapped() {
        guard let product = product else { return }
        viewModel?.addToCart(product)
    }
}
