//
//  GIFsDataStore.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 29/08/2021.
//

import RealmSwift

class GIFsDataStore: DataStoreProtocol {
    
    private let database: Realm
    
    init?() {
        guard let realm = try? Realm() else {
            return nil
        }
        self.database = realm
    }
    
    func saveItem(_ item: DataStoreGIF) {
        try? database.write {
            database.add(item, update: .modified)
        }
    }
    
    func getItem(id: String) -> DataStoreGIF? {
        database.object(ofType: DataStoreGIF.self, forPrimaryKey: id)
    }
    
    func getAllItems() -> [DataStoreGIF] {
       Array(database.objects(DataStoreGIF.self))
    }
    
    func deleteItem(id: String) {
        guard let item = getItem(id: id) else {
            return
        }
        try? database.write {
            database.delete(item)
        }
    }
    
    func hasItem(id: String) -> Bool {
        getItem(id: id) != nil
    }
    
}
