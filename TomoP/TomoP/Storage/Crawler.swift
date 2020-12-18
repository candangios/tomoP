//
//  Crawler.swift
//  TomoP
//
//  Created by CanDang on 12/16/20.
//  Copyright © 2020 CanDang. All rights reserved.
//

import Foundation
import RealmSwift



class Crawler: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var ownAddress: String = ""
    convenience init(index:Int, ownAddress: String ){
        self.init()
        self.index = index
        self.ownAddress = ownAddress
    }
    override static func primaryKey() -> String? {
        return "ownAddress"
    }
}


