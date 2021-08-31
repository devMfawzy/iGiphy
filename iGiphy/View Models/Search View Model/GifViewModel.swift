//
//  GIFViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GIFViewModel {
    
    private var model: GIFModel
    
    init(model: GIFModel) {
        self.model = model
    }
    
    var id: String {
        model.id
    }
    
    var url: URL? {
        URL(string: model.url)
    }
    
    var isFavourite: Bool {
        model.isFavourite
    }
    
}
