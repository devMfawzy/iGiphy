//
//  TrendingGIFsServiceResource.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 29/08/2021.
//

import Foundation

struct TrendingGIFsServiceResource: ServiceResourceProtocol {
    
    var endpoint: ServiceEndpoint {
        ServiceEndpoint.trending
    }
    
    var query: String? = nil
    var offset: Int
    
}
