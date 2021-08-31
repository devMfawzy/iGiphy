//
//  GIFViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GIFViewModel {
    
    let id: String
    let url: URL?
    var isFavourite: Bool

    init(model: GIFModel) {
        self.id = model.id
        self.url = URL(string: model.url)
        self.isFavourite = model.isFavourite
    }
    
}
