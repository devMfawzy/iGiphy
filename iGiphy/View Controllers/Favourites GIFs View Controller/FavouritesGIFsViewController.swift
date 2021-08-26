//
//  FavouritesGIFsViewController.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import UIKit

class FavouritesGIFsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        collectionView.reloadData()
    }
    
    private func setupViews() {
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .babyPurple
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}
