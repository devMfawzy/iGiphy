//
//  GifListViewModeling.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxCocoa

protocol GifListViewModeling {
    func fetchTrendingGifList()
    func searchForGifs(query: String)
    var gifList: Driver<[GifViewModel]> { get }
}
