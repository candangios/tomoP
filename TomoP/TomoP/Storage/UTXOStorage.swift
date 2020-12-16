//
//  UTXOStorage.swift
//  TomoP
//
//  Created by CanDang on 12/16/20.
//  Copyright © 2020 CanDang. All rights reserved.
//

import Foundation


import Foundation
import RealmSwift

class UTXOStorage {
    let realm: Realm
    
    var UTXOs : [UTXO]{
        return Array(realm.objects(UTXO.self))
    }
    var index : Int{
        
        return realm.objects(Crawler.self).first!.index
    }
    
    init(realm: Realm) {
        self.realm = realm
        if realm.objects(Crawler.self).first == nil{
            try? realm.write {
                realm.add(Crawler(index: 0), update: .all)
            }
        }
    }
    func updateIndexCrawler(index: Int) {
        let crawler = realm.objects(Crawler.self).first
        try! realm.write {
            crawler!.index = index
        }
    }
    
    func get(for index: String) -> UTXO? {
        let firstUTXO = realm.objects(UTXO.self).filter { $0.index == index }.first
        guard let foundUTXO = firstUTXO else {
            return .none
        }
        return foundUTXO
    }
    
    func store(UTXOs: [UTXO]) {
        try? realm.write {
            realm.add(UTXOs, update: .all)
        }
    }
    
    func delete(UTXOs: [UTXO]) {
        try? realm.write {
            realm.delete(UTXOs)
        }
    }
    
}
