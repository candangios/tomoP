//
//  TomoPAPI.swift
//  TomoWallet
//
//  Created by CanDang on 12/7/20.
//  Copyright © 2020 TomoChain. All rights reserved.
//

import Foundation
import Moya
import BigInt

enum TomoPAPI{
    case getUTXOs(hexData: String)
    case areSpent(hexData: String)
}

extension TomoPAPI: TargetType {
    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "x-os":"iOS",
            "x-os-version": ProcessInfo.processInfo.operatingSystemVersionString
        ]
    }
    
    var baseURL: URL {
        return URL(string: "https://rpc.testnet.tomochain.com/")!
    }
    
    var path: String {
        return ""
    }
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        
        switch self {
            
        case .getUTXOs(let hexData),.areSpent(let hexData):
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_call",
                "params": [
                    [
                        "to": "0x773f08511DCd7cF4cf259C3D3Bf102a85B81487C",
                        "data": "\(hexData)"
                    ],
                    "latest"
                ],
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
}


