//
//  GiphyService.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift

class GIFsService: ServiceProtocol {
    
    func fetchGIFs(resourceType: ResourceType, offset: Int = 0) ->  Single<GIFsResponse> {
        var url: URL?
        switch resourceType {
        case .getTrendingGIFs:
            url = TrendingGIFsServiceResource(offset: offset).resourceURL
        case .searchGIFsWith(let query):
            url = SearchGIFsServiceResource(query: query, offset: offset).resourceURL
        }
        return fetchGIFs(url: url)
    }
    
    private func fetchGIFs(url: URL?) ->  Single<GIFsResponse> {
        return Single.create { observer -> Disposable in
            guard let url = url else {
                DispatchQueue.main.async {
                    observer(.failure(GIFsServiceError.invalidUrl))
                }
                return Disposables.create()
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let jsonDescoder = JSONDecoder()
                    jsonDescoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let decodedObject = try jsonDescoder.decode(GIFsResponse.self, from: data)
                        DispatchQueue.main.async {
                            observer(.success(decodedObject))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            observer(.failure(error))
                        }
                    }
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    enum GIFsServiceError: Error {
        case invalidUrl
    }
    
}
