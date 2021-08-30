//
//  DataStoreGIF.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 30/08/2021.
//

import RealmSwift

@objcMembers class DataStoreGIF: Object {

    dynamic var id: String = UUID().uuidString
    dynamic var url: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(model: GIFObject) {
        self.init()
        self.id = model.id
        self.url = model.images.fixedWidth.url
    }
    
}
