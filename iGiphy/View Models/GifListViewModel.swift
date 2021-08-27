//
//  GifListViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift
import RxCocoa

struct GifListViewModel: GifListViewModeling {
    
    private let disposeBag = DisposeBag()
    private let service: GiphyServiceProtocol
    private var limit = 25
    private var offset = 0
    private let gifsRelay = BehaviorRelay<[GifViewModel]>(value: [])
    var gifList: Driver<[GifViewModel]> {
        gifsRelay.asDriver()
    }
    
    init(service: GiphyServiceProtocol = GiphyService()) {
        self.service = service
    }
    
    func fetchTrendingGifList() {
        map(observable: service.fetchTrendingGifs(limit: limit, offset: offset))
    }
    
    func searchForGifs(query: String) {
        map(observable: service.searchGifs(query: query, limit: limit, offset: offset))
    }
    
    private func map(observable: Single<GifsResponse>) {
        observable.map {
            $0.data.map( {  GifViewModel(model: $0) })
        }.subscribe(onSuccess: { viewModels in
            gifsRelay.accept(viewModels)
        }, onFailure: { error in
            
        }).disposed(by: disposeBag)
    }
    
}
