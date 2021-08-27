//
//  Gif.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GifObject: Decodable {
    let title: String
    let images: GifImage
}
