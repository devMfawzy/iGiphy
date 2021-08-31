//
//  GIFListViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift
import RxCocoa

struct GIFListViewModel: GIFListViewModeling {
    
    private let disposeBag = DisposeBag()
    private let repository: RepositoryProtocol
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let gifListRelay = BehaviorRelay<[GIFViewModel]>(value: [])
    private let moreGIFsToLoadRelay = BehaviorRelay<Bool>(value: true)

    var gifList: Observable<[GIFViewModel]> {
        gifListRelay.asObservable()
    }
    
    var gifsCount: Int {
        gifListRelay.value.count
    }
    
    var moreGIFsToLoad: Bool {
        moreGIFsToLoadRelay.value
    }
    
    var isLoading: Observable<Bool> {
        isLoadingRelay.asObservable()
    }
    
    init(repository: RepositoryProtocol = GIFsRepository.shared) {
        self.repository = repository
    }
    
    func fetchTrendingGIFList() {
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        repository.fetchNewGIFs(resourceType: .getTrendingGIFs).subscribe(onNext: { values in
            let viewModel = values.map() { GIFViewModel(model: $0) }
            gifListRelay.accept(viewModel)
            isLoadingRelay.accept(false)
            moreGIFsToLoadRelay.accept(true)
        }).disposed(by: disposeBag)
    }
    
    func searchForGIFs(query: String) {
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        repository.fetchNewGIFs(resourceType: .searchGIFsWith(query: query)).subscribe(onNext: { values in
            let viewModel = values.map() { GIFViewModel(model: $0) }
            gifListRelay.accept(viewModel)
            isLoadingRelay.accept(false)
            moreGIFsToLoadRelay.accept(true)
        }).disposed(by: disposeBag)
    }
    
    func loadMoreGIFs() {
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        repository.loadMoreGIFs().subscribe(onNext: { values in
            let viewModel = values.map() { GIFViewModel(model: $0) }
            gifListRelay.accept(viewModel)
            isLoadingRelay.accept(false)
            moreGIFsToLoadRelay.accept(true)
        }).disposed(by: disposeBag)
    }
    
    func toggleFavourite(id: String) {
        guard let gif = gifListRelay.value.first(where: { $0.id == id }) else { return }
        updateGIFFavouriteStatus(gif: gif)
    }
    
    func updateGIFFavouriteStatus(gif: GIFViewModel) {
        if gif.isFavourite {
            repository.deleteGIF(id: gif.id)
        } else {
            repository.saveGIF(id: gif.id)
        }
    }
    
    private func handleError(_ error: Error) {
        isLoadingRelay.accept(false)
        if error as! RepositoryError == RepositoryError.noMoreRemoteGifs {
            self.moreGIFsToLoadRelay.accept(false)
        }
    }
    
}
