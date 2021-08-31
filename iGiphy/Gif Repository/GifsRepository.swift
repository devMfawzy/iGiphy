//
//  GIFsRepository.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 28/08/2021.
//

import RxSwift
import RxRelay

class GIFsRepository: RepositoryProtocol {
    
    private var dataStore: DataStoreProtocol?
    private let service: ServiceProtocol
    private var pagination = Pagination()
    private let disposeBag = DisposeBag()
    private var remoteGIFs = [GIFModel]()
    private let remoteGIFstRelay = PublishRelay<[GIFModel]>()
    private lazy var localGIFsRelay = BehaviorRelay<[GIFModel]>(value: allSavedGIFModels)
    
    private var resourceType: ResourceType {
        willSet {
            pagination = Pagination()
        }
    }
    
    static let shared = GIFsRepository(defaultResource: .getTrendingGIFs)

    private init(defaultResource: ResourceType, service: ServiceProtocol = GIFsService(),
         dataStore: DataStoreProtocol? = GIFsDataStore()) {
        self.resourceType = defaultResource
        self.service = service
        self.dataStore = dataStore
    }
    
    func fetchNewGIFs(resourceType: ResourceType) -> Observable<[GIFModel]> {
        self.resourceType = resourceType
        let observable = service.fetchGIFs(resourceType: resourceType, offset: pagination.offset)
        handle(observable: observable).subscribe(onSuccess: { [weak self] gifModels in
            guard let self = self else { return }
            self.remoteGIFs = gifModels
            self.remoteGIFstRelay.accept(self.remoteGIFs)
        }).disposed(by: disposeBag)
        return self.remoteGIFstRelay.asObservable()
    }
    
    func loadMoreGIFs() -> Observable<[GIFModel]> {
        guard pagination.count < pagination.totalCount else {
            return Observable<[GIFModel]>.error(RepositoryError.noMoreRemoteGifs)
        }
        let newOffset = pagination.offset + pagination.count
        let observable = service.fetchGIFs(resourceType: self.resourceType, offset: newOffset)
        handle(observable: observable).subscribe(onSuccess: { [weak self] gifModels in
            guard let self = self else { return }
            self.remoteGIFs.append(contentsOf: gifModels)
            self.remoteGIFstRelay.accept(self.remoteGIFs )
        }).disposed(by: disposeBag)
        return self.remoteGIFstRelay.asObservable()
    }
    
    private func handle(observable: Single<GIFsResponse>) -> Single<[GIFModel]> {
        savePaginationInfo(observable)
        return mapResponseToModel(observable)
    }
    
    private func mapResponseToModel(_ response: Single<GIFsResponse>) -> Single<[GIFModel]> {
        response.map( { [weak self] resoinse in
            resoinse.data.map {
                let isFavourite = self?.hasGIF(id: $0.id) ?? false
                return GIFModel(object: $0, isFavourite: isFavourite)
            }
        })
    }
    
    func saveGIF(id: String) {
        toggleRemoteFavouriteGIF(id: id)
        if let gif = remoteGIF(id: id) {
            dataStore?.saveItem(DataStoreGIF(model: gif))
            localGIFsRelay.accept(allSavedGIFModels)
        }
    }
        
    func deleteGIF(id: String) {
        toggleRemoteFavouriteGIF(id: id)
        dataStore?.deleteItem(id: id)
        localGIFsRelay.accept(allSavedGIFModels)
    }
    
    func allSavedGIFs() -> Observable<[GIFModel]> {
        localGIFsRelay.asObservable()
    }
    
    func hasGIF(id: String) -> Bool {
        dataStore?.hasItem(id: id) ?? false
    }
    
    // Helper functions & properties
    
    private var allSavedGIFModels: [GIFModel] {
        dataStore?.getAllItems().map( { GIFModel(storedGIF: $0) } ) ?? []
    }
    
    private func toggleRemoteFavouriteGIF(id: String) {
        guard let targetIndex = indexOfRemoteGIF(id: id) else { return }
        remoteGIFs[targetIndex].isFavourite.toggle()
        remoteGIFstRelay.accept(remoteGIFs)
    }
    
    private func indexOfRemoteGIF(id: String) -> Array<GIFModel>.Index? {
        remoteGIFs.firstIndex(where: { $0.id == id })
    }
    
    private func remoteGIF(id: String) -> GIFModel? {
        remoteGIFs.first(where: { $0.id == id })
    }
    
    private func savePaginationInfo(_ response: Single<GIFsResponse>) {
        response.map( { $0.pagination }).subscribe(onSuccess: { [weak self] pagination in
            self?.pagination = pagination
        }).disposed(by: disposeBag)
    }
    
}
