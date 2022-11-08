//
//  CartViewController.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import UIKit
import Combine

class CartViewController: UIViewController {
    
    private let viewModel: CartViewModel
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var footer: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: 0, height: 44)) // Width is determined by UITableView
        let totalLabel = UILabel()
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.text = "Total (kr): "
        totalLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        view.addSubview(totalLabel)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: totalLabel.leadingAnchor, constant: -24),
            view.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor)
        ])
        
        view.addSubview(totalPriceLabel)
        
        NSLayoutConstraint.activate([
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor, constant: 8),
            totalPriceLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.tableFooterView = footer
        return tableView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*,unavailable) required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        self.view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        title = "Cart"
        
        viewModel
            .products
            .sink { [tableView] products in
                tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.totalKronar.sink { [totalPriceLabel] total in
            totalPriceLabel.text = String(total)
        }
        .store(in: &cancellables)
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = viewModel.products.value[indexPath.row]
        let cell = UITableViewCell()
        var state = cell.defaultContentConfiguration()
        state.text = product.name
        cell.contentConfiguration = state
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeProduct(atIndex: indexPath.row)
        }
    }
}
