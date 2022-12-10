//
//  ViewController.swift
//  TestProject
//
//  Created by Alisher Orazbay on 10.11.2022.
//

import UIKit

class ProductsViewController: UIViewController {
    
    private var tableView = UITableView()
    
    private var products: [ProductData.Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let productsViewModel = ProductsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTable()
        setupBinders()
        productsViewModel.getProducts()
    }

    
    func setupBinders() {
        productsViewModel.products.bind { [weak self] products in
            if let products = products {
                self?.products = products.products
            }
        }
    }
    
    
    func setupTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(ProductsTableViewCell.self, forCellReuseIdentifier: ProductsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
    }
}


// MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as! ProductsTableViewCell
        cell.product = products[indexPath.row]
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailsViewController()
        vc.details = products[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
