//
//  GIFCollectionViewCell.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 30/08/2021.
//

import RxSwift
import Kingfisher

class GIFCollectionViewCell: UICollectionViewCell, ReusableViewIdentifiable {
    
    @IBOutlet private(set) weak var gifImageView: UIImageView!
    @IBOutlet private(set) weak var unfavouriteButton: UIButton!
    
    private(set) var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        unfavouriteButton.setTitleColor(.red, for: [])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(viewModel: GIFViewModel) {
        unfavouriteButton.isHidden = true
        self.gifImageView.kf.setImage(with: viewModel.url) { [weak self]_ in
            self?.unfavouriteButton.isHidden = false
        }

    }

}
