//
//  TomoPCoordinator.swift
//  TomoWallet
//
//  Created by CanDang on 12/7/20.
//  Copyright © 2020 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import TrustKeystore
import  Moya
import Moya
import Alamofire
import PromiseKit
class TomoPCoordinator {
    
    let privateKey = "6378de134e758bd024ccaf0e6d5508f4911ba57d2c1e79d15c099d0d7f285a8d"
    let privSpendKey: String = ""
    let scannedTo = 0
    let LIMITED_SCANNING_UTXOS = 100
    let networkService = TomoPNetwork(provider: MoyaProvider<TomoPAPI>())
    let jsBridge: JSBridge
    init?() {
        guard let jsB = JSBridge() else {
            return nil
        }
        self.jsBridge = jsB
        
        scan(fromIndex: 0)
    }

    func scan(fromIndex: Int?) {
        firstly {
            networkService.getUTXOs(index: fromIndex!, limit: LIMITED_SCANNING_UTXOS)
        }.done {utxos in
            let newUTXOs = utxos.filter{$0.commitmentX.description != "0"}
            let privSpendKey = self.jsBridge.privSpendKey(pk: self.privateKey)
            var own_utxos = [UTXO]()
            for utxo in newUTXOs{
                if self.jsBridge.checkOwnership(utxo: utxo, privSpendKey: privSpendKey!) != .none{
                    own_utxos.append(utxo)
                }
            }
            let bytes = self.jsBridge.getkeyImage(utxos: own_utxos, pk: self.privateKey)
            let 
            print(ABIType.dynamicBytes(bytes))
            print(bytes?.bytesToHex(spacing: "").lowercased())
      
            let a = TomoPEncoder.areSpent(data: "033f56956855a5eeded5640e44e5961e4c28656873d643ccaa6a8b229324c01959")
            print(a.hexEncoded)

        }.catch { error in
            
        }
    }
}
