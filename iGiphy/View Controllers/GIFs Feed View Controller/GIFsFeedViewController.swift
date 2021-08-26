//
//  GIFsFeedViewController.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import UIKit

class GIFsFeedViewController: UIViewController {

    @IBOutlet private(set) weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!

    private let tableContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = .babyPurple
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldBackgroundColor(.white)
    }
    
    private func setupTableView() {
        tableView.contentInset = tableContentInset
    }
}
