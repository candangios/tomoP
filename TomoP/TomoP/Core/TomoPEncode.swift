//
//  TomoPEncode.swift
//  TomoWallet
//
//  Created by CanDang on 12/7/20.
//  Copyright © 2020 TomoChain. All rights reserved.
//


import Foundation
import TrustCore
import BigInt
import TrezorCrypto

class TomoPEncoder{
    public static func getUTXOs(index: Int, limit: Int) -> Data {
        let function = Function(name: "getUTXOs", parameters: [.dynamicArray(.uint(bits: 256))])
        let encoder = ABIEncoder()
        let range = Array(index...index+limit)
        try! encoder.encode(function: function, arguments: [range])
        return encoder.data
    }
    public static func areSpent(data: Data) -> Data{
        let function = Function(name: "areSpent", parameters: [.dynamicBytes])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [data])
        return encoder.data
    }
    public static func genDepositProof() -> Data{
        let function = Function(name: "deposit", parameters: [.uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256),.uint(bits: 256), .bytes(137)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [])
        return encoder.data
    }
    public static func privateSend() -> Data{
        let function = Function(name: "privateSend", parameters: [.uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256),.uint(bits: 256), .bytes(137)])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [])
        return encoder.data
    }
    public static func withdrawFunds() -> Data{
        let function = Function(name: "withdrawFunds", parameters: [.uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256), .uint(bits: 256),.uint(bits: 256), .bytes(137)])
               let encoder = ABIEncoder()
               try! encoder.encode(function: function, arguments: [])
               return encoder.data
    }
}



extension Array where Element == UInt8 {
    var data : Data{
        return Data(self)
    }
}



