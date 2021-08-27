//
//  API.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import Foundation

struct API {
    
    static let baseUrl = "https://api.giphy.com/v1/gifs"
    
    struct Endpoint {
        static let trending = "/trending"
        static let search = "/search"
    }
    
    struct KeyName {
        static let accessToken = "api_key"
        static let query = "q"
    }
    
    struct KeyValue {
        static let token = "WVk183ltBkX8KvP9fZo6AkZqLzxBj6tE"
    }
    
}
