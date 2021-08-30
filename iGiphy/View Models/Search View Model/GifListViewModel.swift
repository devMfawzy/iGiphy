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
    
    init(repository: RepositoryProtocol = GIFsRepository(defaultResource: .getTrendingGIFs)) {
        self.repository = repository
    }
    
    func fetchTrendingGIFList() {
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        let observableModels = repository.fetchNewGIFs(resourceType: .getTrendingGIFs)
        let observableViewModels = mapToViewModel(observableModels)
        setNewViewModels(observableViewModels)
    }
    
    func searchForGIFs(query: String) {
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        let observableModels = repository.fetchNewGIFs(resourceType: .searchGIFsWith(query: query))
        let observableViewModels = mapToViewModel(observableModels)
        setNewViewModels(observableViewModels)
    }
    
    func loadMoreGIFs() {
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        let observableModels = repository.loadMoreGIFs()
        mapToViewModel(observableModels)
            .subscribe( onSuccess: { newViewModels in
                var viewmodels = self.gifListRelay.value
                viewmodels.append(contentsOf: newViewModels)
                gifListRelay.accept(viewmodels)
                isLoadingRelay.accept(false)
                moreGIFsToLoadRelay.accept(true)
            }, onFailure: { error in
                handleError(error)
            }).disposed(by: disposeBag)
    }
    
    func toggleFavourite(id: String) {
        var elements = gifListRelay.value
        guard let targetIndex = elements.firstIndex(where: { $0.id == id }) else { return }
        elements[targetIndex].isFavourite.toggle()
        gifListRelay.accept(elements)
        updateDataStore(gif: elements[targetIndex])
    }
    
    func updateDataStore(gif: GIFViewModel) {
        let model = gif.model
        if gif.isFavourite {
            let dataStoreGIF = DataStoreGIF(model: model)
            repository.saveGIF(dataStoreGIF)
        } else {
            repository.deleteGIF(id: model.id)
        }
    }
    
    private func mapToViewModel(_  model: Single<[GIFObject]>) -> Single<[GIFViewModel]> {
        model.map { $0.map( {
            var viewModel = GIFViewModel(model: $0)
            viewModel.isFavourite = repository.hasGIF(id: $0.id)
            return viewModel
        })}
    }
    
    private func setNewViewModels(_ observableViewModels: PrimitiveSequence<SingleTrait, [GIFViewModel]>) {
        observableViewModels.subscribe(onSuccess: { viewModels in
            gifListRelay.accept(viewModels)
            isLoadingRelay.accept(false)
            moreGIFsToLoadRelay.accept(true)
        }, onFailure: { error in
            handleError(error)
        }).disposed(by: disposeBag)
    }
    
    private func handleError(_ error: Error) {
        isLoadingRelay.accept(false)
        if error as! RepositoryError == RepositoryError.noMoreRemoteGifs {
            self.moreGIFsToLoadRelay.accept(false)
        }
    }
    
}
