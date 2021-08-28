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
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let gifListRelay = BehaviorRelay<[GifViewModel]>(value: [])
    
    var gifList: Observable<[GifViewModel]> {
        gifListRelay.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        isLoadingRelay.asObservable()
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
        isLoadingRelay.accept(true)
        observable.map {
            $0.data.map( {  GifViewModel(model: $0) })
        }.subscribe(onSuccess: { viewModels in
            gifListRelay.accept(viewModels)
            isLoadingRelay.accept(false)
        }, onFailure: { error in
            
        }).disposed(by: disposeBag)
    }
    
    func toggleFavourite(id: String) {
        var elements = gifListRelay.value
        guard let targetIndex = elements.firstIndex(where: { $0.id == id }) else { return }
        elements[targetIndex].isFavourite.toggle()
        gifListRelay.accept(elements)
    }
    
}
