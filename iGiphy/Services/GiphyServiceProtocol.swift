//
//  GiphyServiceProtocol.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift

protocol GiphyServiceProtocol {
    func fetchTrendingGifs(limit: Int, offset: Int) ->  Single<GifsResponse>
    func searchGifs(query: String, limit: Int, offset: Int) ->  Single<GifsResponse>
}
