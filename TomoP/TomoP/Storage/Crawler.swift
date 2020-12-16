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
    @objc dynamic var name = "Crawler"
    @objc dynamic var index: Int = 0
    convenience init(index:Int ){
        self.init()
        self.index = index
    }
    override static func primaryKey() -> String? {
        return "name"
    }
}


