//
//  FullScreenGIFViewController.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 31/08/2021.
//

import UIKit
import RxRelay
import RxSwift
import Kingfisher

class FullScreenGIFViewController: UIViewController {

    @IBOutlet private(set) weak var gifImageView: UIImageView!
    @IBOutlet private(set) weak var favouriteButton: UIButton!
    @IBOutlet private(set) weak var shareButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let repository: RepositoryProtocol
    private var viewModelRelay: BehaviorRelay<GIFViewModel>
    
    init(viewModel: GIFViewModel, repository: RepositoryProtocol = GIFsRepository.shared) {
        viewModelRelay = BehaviorRelay(value: viewModel)
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gifImageView.kf.setImage(with: viewModelRelay.value.url)
        self.viewModelRelay.subscribe(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.setFavouriteButton(isFavourite: viewModel.isFavourite)
        }).disposed(by: disposeBag)
        bindFavouriteButton(favouriteButton)
        bindShareButton(shareButton, url: viewModelRelay.value.url)
    }
    
    private func bindShareButton(_ button: UIButton, url: URL?) {
        button.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let url = url else {
                    return
                }
                let items = [url]
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(activityViewController, animated: true)
            }).disposed(by: disposeBag )
    }
    
    private func bindFavouriteButton(_ button: UIButton) {
        button.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                var viewModel = self.viewModelRelay.value
                self.toggleFavouriteStatus(gifId: viewModel.id , isFavourite: viewModel.isFavourite)
                viewModel.isFavourite.toggle()
                self.viewModelRelay.accept(viewModel)
            }).disposed(by: disposeBag )
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func toggleFavouriteStatus(gifId: String, isFavourite: Bool) {
        isFavourite ? repository.deleteGIF(id: gifId) : repository.saveGIF(id: gifId)
    }
    
    private func setFavouriteButton(isFavourite: Bool) {
        let image = isFavourite ? #imageLiteral(resourceName: "favorite.fill") : #imageLiteral(resourceName: "favorite")
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        favouriteButton.setImage(tintedImage, for: .normal)
        favouriteButton.tintColor = isFavourite ? .red : .gray
    }

}
