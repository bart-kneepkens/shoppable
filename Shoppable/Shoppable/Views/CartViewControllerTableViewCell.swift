//
//  CartViewControllerTableViewCell.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import UIKit

class CartViewControllerTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "cart-cell"
    
    var product: Product? {
        didSet {
            self.setNeedsUpdateConfiguration()
        }
    }
    
    var imageData: Data? {
        didSet {
            self.setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var contentConfig = defaultContentConfiguration().updated(for: state)
        
        contentConfig.text = product?.name
        
        if let price = product?.price {
            contentConfig.secondaryText = "\(price.currency.rawValue) \(String(price.value))"
        }
        
        if let imageData = imageData, let image = UIImage(data: imageData) {
            contentConfig.image = image
        }
        
        contentConfiguration = contentConfig
    }
}

