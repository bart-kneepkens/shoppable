//
//  ProductCatalogViewController.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import UIKit

private enum Section: Hashable{
    case main
}

class ProductCatalogViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: productCollectionLayout)
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Product> = {
        let cellRegistration = UICollectionView.CellRegistration<ProductCollectionViewCell, Product> { cell, _, product in
            cell.product = product
        }
        
        return UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, identifier -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }()
    
    override func loadView() {
        self.view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        
        // Fake snapshot for testing data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems([Product(id: "1", name: "BART", type: .chair, price: .init(value: 2, currency: .kr), imageUrl: "", info: .init(color: "red", material: "wood", numberOfSeats: 4))], toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - UICollectionViewLayout

extension ProductCatalogViewController {
    private var productCollectionLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8) // Spacing between cells
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(128))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

