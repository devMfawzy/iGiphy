//
//  DataStoreProtocol.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 29/08/2021.
//

import Foundation

protocol DataStoreProtocol {
    func saveItem(_ item: DataStoreGIF)
    func getItem(id: String) -> DataStoreGIF?
    func getAllItems() -> [DataStoreGIF]
    func deleteItem(id: String)
    func hasItem(id: String) -> Bool
}
