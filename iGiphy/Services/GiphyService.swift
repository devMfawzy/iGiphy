//
//  GiphyService.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import RxSwift

class GiphyService: GiphyServiceProtocol {
    
    func fetchTrendingGifs(limit: Int = 25, offset: Int = 0) -> Single<GifsResponse> {
        fetchGifs(url: GiphyApi.trendingAPIUrl, limit: limit, offset: offset)
    }
    
    func searchGifs(query: String, limit: Int = 25, offset: Int = 0) ->  Single<GifsResponse> {
        fetchGifs(url: GiphyApi.searchAPIUrl(query: query), limit: limit, offset: offset)
    }
    
    private func fetchGifs(url: URL?, limit: Int, offset: Int ) ->  Single<GifsResponse> {
        return Single.create { observer -> Disposable in
            guard let url = url else {
                DispatchQueue.main.async {
                    observer(.failure(GiphyServiceError.invalidUrl))
                }
                return Disposables.create()
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let jsonDescoder = JSONDecoder()
                    jsonDescoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let decodedObject = try jsonDescoder.decode(GifsResponse.self, from: data)
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
    
    enum GiphyServiceError: Error {
        case invalidUrl
    }
    
}
