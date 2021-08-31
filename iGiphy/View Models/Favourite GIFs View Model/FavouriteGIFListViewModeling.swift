//
//  FavouriteGIFListViewModeling.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 30/08/2021.
//

import RxSwift

protocol FavouriteGIFListViewModeling {
    func deleteGIF(id: String)
    var favouriteGIFList: Observable<[GIFViewModel]> { get }
}
