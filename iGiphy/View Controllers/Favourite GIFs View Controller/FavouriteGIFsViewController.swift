//
//  FavouriteGIFsViewController.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import UIKit
import RxSwift
import RxCocoa

class FavouriteGIFsViewController: UIViewController {
    
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var viewModel: FavouriteGIFListViewModeling = FavouriteGIFListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews() {
        setupNavigationController()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        viewModel.favouriteGIFList.bind(to: collectionView.rx.items(cellIdentifier: GIFCollectionViewCell.identifier)) { [weak self] index, GIFViewModel, cell in
            if let cell = cell as? GIFCollectionViewCell {
                cell.configure(viewModel: GIFViewModel)
                cell.unfavouriteButton.rx.tap
                    .asDriver()
                    .drive(onNext: {
                        self?.viewModel.deleteGIF(id: GIFViewModel.id)
                    }).disposed(by: cell.disposeBag )
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .babyPurple
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}
