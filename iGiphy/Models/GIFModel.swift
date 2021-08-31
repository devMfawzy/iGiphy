//
//  GIFModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 30/08/2021.
//

import Foundation

struct GIFModel {
    
    let id: String
    let url: String
    var isFavourite = false
    
    init(object: GIFObject, isFavourite: Bool = false) {
        self.id = object.id
        self.url = object.images.fixedWidth.url
        self.isFavourite = isFavourite
    }
    
    init(storedGIF: DataStoreGIF) {
        self.id = storedGIF.id
        self.url = storedGIF.url
        self.isFavourite = true
    }
    
}
