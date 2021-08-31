//
//  FavouriteGIFsViewModel.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 30/08/2021.
//

import RxSwift
import RxCocoa

struct FavouriteGIFListViewModel: FavouriteGIFListViewModeling {
    
    private let disposeBag = DisposeBag()
    private let repository: RepositoryProtocol

    init(repository: RepositoryProtocol = GIFsRepository.shared) {
        self.repository = repository
    }
    
    func deleteGIF(id: String) {
        repository.deleteGIF(id: id)
    }
    
    var favouriteGIFList: Observable<[GIFViewModel]> {
        repository.allSavedGIFs().map { $0.map { GIFViewModel(model: $0) } }
    }
    
}
