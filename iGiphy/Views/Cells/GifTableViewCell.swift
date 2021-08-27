//
//  GifTableViewCell.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 27/08/2021.
//

import UIKit
import SwiftyGif

class GifTableViewCell: UITableViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
    
    func configure(viewModel: GifViewModel) {
        if let url = viewModel.url {
            let loader = UIActivityIndicatorView(style: .medium)
            self.gifImageView.setGifFromURL(url, customLoader: loader)
        }
    }
    
}
