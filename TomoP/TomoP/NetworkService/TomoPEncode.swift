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
    public static func getUTXO(index: Int) -> Data {
           let function = Function(name: "getUTXO", parameters: [.uint(bits: 256)])
           let encoder = ABIEncoder()
           try! encoder.encode(function: function, arguments: [index])
           return encoder.data
           
       }
    
    public static func areSpent(data: String) -> Data {
        let function = Function(name: "areSpent", parameters: [.dynamicBytes])
        let encoder = ABIEncoder()
        try! encoder.encode(function: function, arguments: [data.data(using: .utf8)])
        return encoder.data
        
    }
    
    
    public static func bytesToHex(bytes: [UInt32], spacing: String) -> String
    {
        var hexString: String = ""
        var count = bytes.count
        for byte in bytes
        {
            hexString.append(String(format:"%02X", byte))
            count = count - 1
            if count > 0
            {
                hexString.append(spacing)
            }
        }
        return hexString
    }
}


 extension Array where Element == UInt8 {
  func bytesToHex(spacing: String) -> String {
    var hexString: String = ""
    var count = self.count
    for byte in self
    {
        hexString.append(String(format:"%02X", byte))
        count = count - 1
        if count > 0
        {
            hexString.append(spacing)
        }
    }
    return hexString
}
}
