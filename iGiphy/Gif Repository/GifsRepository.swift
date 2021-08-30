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
    private let gifListRelay = BehaviorRelay<[GIFViewModel]>(value: [])

    private var resourceType: ResourceType {
        willSet {
            pagination = Pagination()
        }
    }
    
    init(defaultResource: ResourceType, service: ServiceProtocol = GIFsService(),
         dataStore: DataStoreProtocol? = GIFsDataStore()) {
        self.resourceType = defaultResource
        self.service = service
        self.dataStore = dataStore
    }
    
    func fetchNewGIFs(resourceType: ResourceType) -> Single<[GIFObject]> {
        self.resourceType = resourceType
        let observable = service.fetchGIFs(resourceType: resourceType, offset: pagination.offset)
        return handle(observable: observable)
    }
    
    func loadMoreGIFs() -> Single<[GIFObject]> {
        guard pagination.count < pagination.totalCount else {
            return Single<[GIFObject]>.error(RepositoryError.noMoreRemoteGifs)
        }
        let newOffset = pagination.offset + pagination.count
        let observable = service.fetchGIFs(resourceType: self.resourceType, offset: newOffset)
        return handle(observable: observable)
    }
    
    private func handle(observable: Single<GIFsResponse>) -> Single<[GIFObject]> {
        observable.map( { $0.pagination }).subscribe(onSuccess: { [weak self] pagination in
            self?.pagination = pagination
        }).disposed(by: disposeBag)
        return observable.map( { $0.data })
    }
    
    func saveGIF(_ gif: DataStoreGIF) {
        dataStore?.saveItem(gif)
    }
    
    func deleteGIF(id: String) {
        dataStore?.deleteItem(id: id)
    }
    
    func allSavedGIFs() -> [DataStoreGIF] {
        dataStore?.getAllItems() ?? []
    }
    
    func hasGIF(id: String) -> Bool {
        dataStore?.hasItem(id: id) ?? false
    }

    
}
