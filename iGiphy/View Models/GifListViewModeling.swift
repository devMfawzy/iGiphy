//
//  GifListViewModeling.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift

protocol GifListViewModeling {
    func fetchTrendingGifList()
    func searchForGifs(query: String)
    func toggleFavourite(id: String)
    var gifList: Observable<[GifViewModel]> { get }
    var isLoading: Observable<Bool> { get }
}
