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



/* UTXO structure input
    * 0 - [commitmentX, pubkeyX, txPubX],
    * 1 - [commitmentYBit, pubkeyYBit, txPubYBit],
    * 2 - [EncryptedAmount, EncryptedMask],
    * 3 - _index
    * 4 - txID
*/



struct UTXO {
    var commitmentX: BigUInt!
    var commitmentYBit: BigUInt!
    var pubkeyX: BigUInt!
    var pubkeyYBit: BigUInt!
    var amount: BigUInt!
    var mask: BigUInt!
    var txPubX: BigUInt!
    var txPubYBit: BigUInt!
    var index: BigUInt!
    var txid: BigUInt!
    var areSpent: Bool = false
    var amountValue = "0"
    init?(data: ABIValue){
        switch data {
        case.tuple(let values):
            for value in values{
                switch value.type {
                case.array(.uint(bits: 256), 3):
                    let arr_values: Array = value.nativeValue as! Array<BigUInt>
                    self.commitmentX = arr_values[0]
                    self.pubkeyX = arr_values[1]
                    self.txPubX = arr_values[2]
                case .array(.uint(bits: 8), 3):
                    let arr_values: Array = value.nativeValue as! Array<BigUInt>
                    self.commitmentYBit = arr_values[0]
                    self.pubkeyYBit = arr_values[1]
                    self.txPubYBit = arr_values[2]
                case .array(.uint(bits: 256), 2):
                    let arr_values: Array = value.nativeValue as! Array<BigUInt>
                    self.amount = arr_values[0]
                    self.mask = arr_values[1]
                case .uint(bits: 256):
                    self.index = values[3].nativeValue as? BigUInt
                    self.txid = values[4].nativeValue as? BigUInt
                default:
                    break
                }
            }
           
        default:
            
            return nil
        }
    }
}

