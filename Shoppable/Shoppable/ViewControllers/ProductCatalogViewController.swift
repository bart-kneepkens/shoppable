//
//  ProductCatalogViewController.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import UIKit
import Combine

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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        UIActivityIndicatorView()
    }()
    
    private let viewModel = ProductCatalogViewModel(productCatalogProvider: JSONFileProductCatalogProvider(Bundle.main.url(forResource: "products", withExtension: "json")!))
    
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        self.view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        navigationItem.rightBarButtonItem = .init(customView: activityIndicator)
        
        viewModel.loadProducts()
        
        viewModel
            .state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: ProductCatalogViewModel.State) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .loaded(let products):
            activityIndicator.stopAnimating()
            applySnapshotToDataSource(using: products)
        default: break
        }
    }
    
    private func applySnapshotToDataSource(using products: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products, toSection: .main)
        dataSource.apply(snapshot)
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

