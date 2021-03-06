//
//  RepositoryProtocol.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 28/08/2021.
//

import RxSwift

protocol RepositoryProtocol {
    func fetchNewGIFs(resourceType: ResourceType) -> Observable<[GIFModel]>
    func loadMoreGIFs() -> Observable<[GIFModel]>
    func saveGIF(id: String)
    func deleteGIF(id: String)
    func allSavedGIFs() -> Observable<[GIFModel]>
    func hasGIF(id: String) -> Bool
}
