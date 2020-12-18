//
//  TomoPProtocol.swift
//  TomoWallet
//
//  Created by CanDang on 12/7/20.
//  Copyright © 2020 TomoChain. All rights reserved.
//

import Foundation

import Foundation
import Moya
import TrustCore
import BigInt
import PromiseKit


protocol TomoPProtocol{
    func getUTXOs(index: Int, limit: Int, ownAddress: String) -> Promise<[UTXO]>
    func areSpent(utxos: [UTXO], data: Data, hexCode: String) -> Promise<[Bool]>
}
final class TomoPNetwork : TomoPProtocol{
    func areSpent(utxos: [UTXO] ,data: Data, hexCode: String) -> Promise<[Bool]> {
        return Promise{ seal in
            let encode = TomoPEncoder.areSpent(data: data)
            let hex = String(encode.hexEncoded.prefix(138)) + hexCode
            provider.request(.getUTXOs(hexData:hex)) { results in
                switch results{
                case .success(let res):
                    do {
                        let balanceDecodable = try res.map(RPCTomoPResults.self)
                        let a = String(balanceDecodable.result.dropFirst(130))
                        let data = Data(hex: a)
                        let decoder = ABIDecoder(data: data)
                        let utsxos_areSpent = try decoder.decodeArray(type: .bool, count: data.count/32)
                        var areSpent_UTXOs = [Bool]()
                        if utsxos_areSpent.count > 0{
                            for index in 0...utsxos_areSpent.count - 1 {
                                switch utsxos_areSpent[index] {
                                case .bool(let areSpent):
                                    areSpent_UTXOs.append(areSpent)
                                default:
                                    break
                                }
                            }
                        }
                        seal.fulfill(areSpent_UTXOs)
                    } catch  {
                        seal.reject(error)
                    }
                    
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func getUTXOs(index: Int, limit: Int, ownAddress: String) -> Promise<[UTXO]> {
        return Promise{ seal in
            let encode = TomoPEncoder.getUTXOs(index: index, limit:limit-1)
            provider.request(.getUTXOs(hexData:encode.hexEncoded)) { results in
                switch results{
                case .success(let res):
                    do {
                        let balanceDecodable = try res.map(RPCTomoPResults.self)
                        let data = Data(hexString: String(balanceDecodable.result.drop0x.dropFirst(128)))
                        let decoder = ABIDecoder(data: data!)
                        let utsxos = try decoder.decodeArray(type:.tuple([.array(.uint(bits: 256), 3), .array(.uint(bits: 8), 3), .array(.uint(bits: 256), 2),.uint(bits: 256), .uint(bits: 256)]), count: limit)
                        var utxos = [UTXO]()
                        for item in utsxos {
                            if let utxo = UTXO(data: item, ownAddress: ownAddress){
                                utxos.append(utxo)
                            }
                        }
                        seal.fulfill(utxos)
                    } catch  {
                        seal.reject(error)
                    }
                    
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    let provider: MoyaProvider<TomoPAPI>
    init(
        provider: MoyaProvider<TomoPAPI>
    ) {
        self.provider = provider
    }
}

struct RPCTomoPResults: Decodable {
    let result: String
    let jsonrpc: String
    let id :Int64
    
    private enum keys: String, CodingKey {
        case result
        case jsonrpc
        case id
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: keys.self)
        self.result = try values.decode(String.self, forKey: .result)
        self.jsonrpc = try values.decode(String.self, forKey: .jsonrpc)
        self.id = try values.decode(Int64.self, forKey: .id)
    }
}


