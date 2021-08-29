//
//  GIFListViewModeling.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift

protocol GIFListViewModeling {
    func fetchTrendingGIFList()
    func searchForGIFs(query: String)
    func toggleFavourite(id: String)
    func loadMoreGIFs()
    var gifList: Observable<[GIFViewModel]> { get }
    var gifsCount: Int { get }
    var moreGIFsToLoad: Bool { get }
    var isLoading: Observable<Bool> { get }
}
