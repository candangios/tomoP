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
import PromiseKit
import Moya
import BigInt
import RealmSwift

class TomoPCoordinator {
    let privateKey = "6378de134e758bd024ccaf0e6d5508f4911ba57d2c1e79d15c099d0d7f285a8d"
    let privSpendKey: String = ""
    let scannedTo = 0
    let LIMITED_SCANNING_UTXOS = 10
    let networkService = TomoPNetwork(provider: MoyaProvider<TomoPAPI>())
    let jsBridge: JSBridge
    var index: Int = 0
    var isScan: Bool = false
    weak var timer:Timer!
    var available_UTXOs = [UTXO]()
    
    let storage: UTXOStorage
    init?(realm: Realm) {
        guard let jsB = JSBridge() else {
            return nil
        }
        self.storage = UTXOStorage(realm: realm)
        self.index = self.storage.index
        self.jsBridge = jsB
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if !self.isScan{
                self.scan()
//                print(self.index)
                print(self.storage.index)
            }
        }
        scan()
//        self.checkAreSpentUTXOs()
//        self.jsBridge.genDepositProof(amount: "1000000000000000000", pk: self.privateKey)
    }
    deinit {
        timer.invalidate()
    }
    

    func scan()  {
        getUTXOs(fromIndex: self.index)
    }
    
    func getUTXOs(fromIndex: Int?) {
        isScan = true
        var isMore = true
        firstly {
            networkService.getUTXOs(index: fromIndex!, limit: LIMITED_SCANNING_UTXOS)
        }.then({ (utxos) -> Promise<[Bool]>  in
            let n_utxos = utxos.filter{$0.commitmentX.description != "0"}
            if n_utxos.count == 0{ isMore = false}
            self.index = self.index + n_utxos.count
            if self.storage.index != self.index{
                self.checkAreSpentUTXOs()
                self.storage.updateIndexCrawler(index: self.index)
            }
    
            let privSpendKey = self.jsBridge.privSpendKey(pk: self.privateKey)
            var own_utxos = [UTXO]()
            for utxo in n_utxos{
                if let amountString = self.jsBridge.checkOwnership(utxo: utxo, privSpendKey: privSpendKey!){
                    if amountString != "0"{
                        utxo.amountValue = amountString
                        own_utxos.append(utxo)
                    }
                }
            }
            if own_utxos.count == 0{
                return Promise{seal in seal.fulfill([Bool]())}
            }
            let data = self.jsBridge.getkeyImage(utxos: own_utxos, pk: self.privateKey)
            return self.networkService.areSpent(utxos: own_utxos, data: data!.data, hexCode: data!.data.toHexString())
        }).done { (areSpent_UTXOs) in
            if self.index%self.LIMITED_SCANNING_UTXOS == 0 && isMore{
                self.scan()
            }else{
                self.isScan = false
            }
            
            
            
//            self.storage.store(UTXOs: UTXOs)
        }.catch { (error) in
            self.isScan = false
            print(error)
        }
    }
    
    func checkAreSpentUTXOs() {
        let own_UTXOs = self.storage.UTXOs
        let data = self.jsBridge.getkeyImage(utxos: own_UTXOs, pk: self.privateKey)
        firstly {
            self.networkService.areSpent(utxos: own_UTXOs, data: data!.data, hexCode: data!.data.toHexString())
        }.done { (areSpent_UTXOs) in
            
//            var resultsArray = [UTXO]()
//
//            let filteredArray = own_UTXOs.filter{ !UTXOs.contains($0) }
//            print(filteredArray)
//
//
            
        }.catch { (error) in
            self.checkAreSpentUTXOs()
        }

    }
    
    
}
