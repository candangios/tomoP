//
//  UTXO.swift
//  TomoP
//
//  Created by CanDang on 12/8/20.
//  Copyright © 2020 CanDang. All rights reserved.
//

import Foundation
import TrustCore
import BigInt
import Realm
import RealmSwift



/* UTXO structure input
    * 0 - [commitmentX, pubkeyX, txPubX],
    * 1 - [commitmentYBit, pubkeyYBit, txPubYBit],
    * 2 - [EncryptedAmount, EncryptedMask],
    * 3 - _index
    * 4 - txID
*/



class UTXO: Object {
    @objc dynamic var ownAddress: String = ""
    @objc dynamic var commitmentX: String = ""
    @objc dynamic var commitmentYBit: String = ""
    @objc dynamic var pubkeyX: String = ""
    @objc dynamic var pubkeyYBit: String = ""
    @objc dynamic var amount: String = ""
    @objc dynamic var mask: String = ""
    @objc dynamic var txPubX: String = ""
    @objc dynamic var txPubYBit: String = ""
    @objc dynamic var index: String = ""
    @objc dynamic var txid: String = ""
    @objc dynamic var areSpent: Bool = false
    @objc dynamic var amountValue = "0"
    convenience init?(data: ABIValue, ownAddress: String){
      
        switch data {
        case.tuple(let values):
            self.init()
            self.ownAddress = ownAddress
            for value in values{
                switch value.type {
                case.array(.uint(bits: 256), 3):
                    let arr_values: Array = value.nativeValue as! Array<BigUInt>
                    self.commitmentX = arr_values[0].description
                    self.pubkeyX = arr_values[1].description
                    self.txPubX = arr_values[2].description
                case .array(.uint(bits: 8), 3):
                    let arr_values: Array = value.nativeValue as! Array<BigUInt>
                    self.commitmentYBit = arr_values[0].description
                    self.pubkeyYBit = arr_values[1].description
                    self.txPubYBit = arr_values[2].description
                case .array(.uint(bits: 256), 2):
                    let arr_values: Array = value.nativeValue as! Array<BigUInt>
                    self.amount = arr_values[0].description
                    self.mask = arr_values[1].description
                case .uint(bits: 256):
                    self.index = (values[3].nativeValue as? BigUInt)?.description ?? ""
                    self.txid = (values[4].nativeValue as? BigUInt)?.description ?? ""
                default:
                    break
                }
            }
           
        default:
            return nil
        }
    }
    override static func primaryKey() -> String? {
        return "index"
    }
    
}

