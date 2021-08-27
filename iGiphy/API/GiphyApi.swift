//
//  GiphyApi.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

extension URL {
    
    static func urlOf(baseUrl: String, endpoint: String, parameters: [String: String]) -> URL? {
        let urlString = "\(baseUrl)\(endpoint)"
        var components = URLComponents(string: urlString)
        components?.queryItems = parameters.map() { URLQueryItem(name: $0, value: $1) }
        return components?.url
    }
    
}

class GiphyApi {
    
    static var trendingAPIUrl: URL? {
        URL.urlOf(baseUrl: API.baseUrl, endpoint: API.Endpoint.trending, parameters: [API.KeyName.accessToken: API.KeyValue.token])
    }
    
    static func searchAPIUrl(query: String) ->  URL? {
        URL.urlOf(baseUrl: API.baseUrl, endpoint: API.Endpoint.search, parameters: [API.KeyName.accessToken: API.KeyValue.token, API.KeyName.query: query])
    }
    
}
