//
//  GIFTableViewCell.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 27/08/2021.
//

import UIKit
import SwiftyGif
import RxSwift
import RxCocoa

class GIFTableViewCell: UITableViewCell {

    @IBOutlet private(set) weak var gifImageView: UIImageView!
    @IBOutlet private(set) weak var favouriteButton: UIButton!
    
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(viewModel: GIFViewModel) {
        if let url = viewModel.url {
            self.gifImageView.setGifFromURL(url, showLoader: false)
            setFavouriteButton(isFavourite: viewModel.isFavourite)
        }
    }
    
    private func setFavouriteButton(isFavourite: Bool) {
        let image = isFavourite ? #imageLiteral(resourceName: "favorite.fill") : #imageLiteral(resourceName: "favorite")
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        favouriteButton.setImage(tintedImage, for: .normal)
        favouriteButton.tintColor = isFavourite ? .red : .gray
    }
    
}
