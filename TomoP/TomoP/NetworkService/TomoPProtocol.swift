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
    func getUTXOs(index: Int, limit: Int) -> Promise<[UTXO]>
    func areSpent(utxo: UTXO) -> Promise<Bool>
}
final class TomoPNetwork : TomoPProtocol{
    func areSpent(utxo: UTXO) -> Promise<Bool> {
        return Promise{seal in
            seal.fulfill(true)
        }
    }
    func getUTXOs(index: Int, limit: Int) -> Promise<[UTXO]> {
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
                            if let utxo = UTXO(data: item){
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


