//
//  Pagination.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 28/08/2021.
//

import Foundation

struct Pagination: Decodable {
    
    var totalCount: Int
    var count: Int
    var offset: Int
    
    init() {
        self.totalCount = 0
        self.count = 0
        self.offset = 0
    }
    
}
