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
        viewModel.favouriteGIFList.bind(to: collectionView.rx.items(cellIdentifier: GIFCollectionViewCell.identifier)) { [weak self] index, gifViewModel, cell in
            if let cell = cell as? GIFCollectionViewCell {
                cell.configure(viewModel: gifViewModel)
                cell.unfavouriteButton.rx.tap
                    .asDriver()
                    .drive(onNext: {
                        self?.viewModel.deleteGIF(id: gifViewModel.id)
                    }).disposed(by: cell.disposeBag )
            }
        }.disposed(by: disposeBag)
        collectionView.rx.modelSelected(GIFViewModel.self)
            .subscribe(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let viewController = FullScreenGIFViewController(viewModel: viewModel)
                self.navigationController?.present(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .babyPurple
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}
