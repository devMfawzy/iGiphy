//
//  GIFTableViewCell.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 27/08/2021.
//

import UIKit
import Kingfisher
import RxSwift

class GIFTableViewCell: UITableViewCell, ReusableViewIdentifiable {

    @IBOutlet private(set) weak var gifImageView: UIImageView!
    @IBOutlet private(set) weak var favouriteButton: UIButton!
    @IBOutlet private(set) weak var shareButton: UIButton!

    
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(viewModel: GIFViewModel) {
        favouriteButton.isHidden = true
        self.gifImageView.kf.setImage(with: viewModel.url) { [weak self]_ in
            self?.favouriteButton.isHidden = false
        }
        setFavouriteButton(isFavourite: viewModel.isFavourite)
    }
    
    private func setFavouriteButton(isFavourite: Bool) {
        let image = isFavourite ? #imageLiteral(resourceName: "favorite.fill") : #imageLiteral(resourceName: "favorite")
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        favouriteButton.setImage(tintedImage, for: .normal)
        favouriteButton.tintColor = isFavourite ? .red : .gray
    }
    
}
