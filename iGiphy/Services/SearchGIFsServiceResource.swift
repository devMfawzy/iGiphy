//
//  SearchGIFsServiceResource.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 29/08/2021.
//

import Foundation

struct SearchGIFsServiceResource: ServiceResourceProtocol {
    
    var queryKey: String {
        API.KeyName.query
    }
    
    var endpoint: ServiceEndpoint {
        ServiceEndpoint.search
    }
    
    var query: String?
    var offset: Int

}
