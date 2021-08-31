//
//  GIF.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct GIFObject: Decodable {
    let id: String
    let images: GIFImage
}
