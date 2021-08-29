//
//  ServiceResourceProtocol.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 28/08/2021.
//

import Foundation

protocol ServiceResourceProtocol {
    var baseURL: String { get }
    var defaultParameters: [String: String] { get }
    var queryKey: String? { get }
    var offsetKey: String? { get }
    var endpoint: ServiceEndpoint { get }
    var query: String? { get }
    var offset: Int { get }
}

extension ServiceResourceProtocol {
    
    var baseURL: String {
        API.baseUrl
    }

    var queryKey: String? {
        API.KeyName.query
    }
    
    var offsetKey: String? {
        API.KeyName.offse
    }
    
    var defaultParameters: [String : String] {
        [API.KeyName.accessToken: API.KeyValue.token, API.KeyName.limit: API.KeyValue.linit]
    }
    
    var resourceURL: URL? {
        let urlString = "\(baseURL)/\(endpoint)"
        var components = URLComponents(string: urlString)
        components?.queryItems = defaultParameters.map() { URLQueryItem(name: $0, value: $1) }
        if let queryKey = queryKey, let queryValue = query {
            components?.queryItems?.append(URLQueryItem(name: queryKey, value: queryValue))
        }
        if let offsetKey = offsetKey {
            components?.queryItems?.append(URLQueryItem(name: offsetKey, value: String(offset)))
        }
        return components?.url
    }
    
    
}
