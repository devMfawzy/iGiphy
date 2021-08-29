//
//  API.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct API {
    
    static let baseUrl = "https://api.giphy.com/v1/gifs"
    
    struct KeyName {
        static let accessToken = "api_key"
        static let query = "q"
        static let limit = "limit"
        static let offse = "offset"
    }
    
    struct KeyValue {
        static let token = "WVk183ltBkX8KvP9fZo6AkZqLzxBj6tE"
        static let linit = "25"
    }
    
}
