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
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
