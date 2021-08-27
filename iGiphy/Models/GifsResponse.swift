//
//  TrendingGifsResponse.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GifsResponse: Decodable {
    let data: [GifObject]
}
