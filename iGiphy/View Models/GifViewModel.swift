//
//  GifViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GifViewModel {
    
    private let model: GifObject
    var isFavourite = false
    
    init(model: GifObject) {
        self.model = model
    }
    
    var id: String {
        model.id
    }
    
    var url: URL? {
        URL(string: model.images.fixedWidth.url)
    }
    
    var title: String {
        model.title
    }
    
}
