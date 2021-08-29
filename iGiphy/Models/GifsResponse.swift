//
//  TrendingGIFsResponse.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GIFsResponse: Decodable {
    let data: [GIFObject]
    let pagination: Pagination
}
