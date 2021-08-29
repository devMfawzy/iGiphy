//
//  RepositoryProtocol.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 28/08/2021.
//

import RxSwift

protocol RepositoryProtocol {
    func fetchNewGIFs(resourceType: ResourceType) -> Single<[GIFObject]>
    func loadMoreGIFs() -> Single<[GIFObject]>
}
