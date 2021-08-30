//
//  GIFViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GIFViewModel {
    
    private(set) var model: GIFObject
    var isFavourite = false
    
    init(model: GIFObject) {
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
