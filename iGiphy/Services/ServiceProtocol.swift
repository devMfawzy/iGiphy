//
//  GiphyServiceProtocol.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift

protocol ServiceProtocol {
    func fetchGIFs(resourceType: ResourceType, offset: Int) ->  Single<GIFsResponse>
}
