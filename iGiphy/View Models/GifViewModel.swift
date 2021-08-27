//
//  GifViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GifViewModel {
    
    private let model: GifObject
    
    init(model: GifObject) {
        self.model = model
    }
    
    var url: URL? {
        URL(string: model.images.fixedWidth.url)
    }
    
    var title: String {
        model.title
    }
    
}
