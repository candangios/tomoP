//
//  JSBridge.swift
//  TomoP
//
//  Created by CanDang on 12/11/20.
//  Copyright © 2020 CanDang. All rights reserved.
//

import Foundation
import JavaScriptCore
import BigInt
class JSBridge {
    let context = JSContext ()
    init?(){
        if let filepath = Bundle.main.path(forResource: "index", ofType: "js") {
            do {
                let jsSource = try String(contentsOfFile: filepath)
                context?.evaluateScript(jsSource)
                context?.exceptionHandler = { context, exception in
                    if let exc = exception {
                        print("JS Exception:", exc.toString() ?? "")
                    }
                }
            } catch {
                return nil
            }
        }
    }
    
    func checkOwnership(utxo: UTXO,privSpendKey: String) -> String?   {
        guard let js = context?.evaluateScript(
            """
            (function(){
            const utxo = {
            '0': {
            '0': '\(utxo.commitmentX.description)',
            '1': '\(utxo.pubkeyX.description)',
            '2': '\(utxo.txPubX.description)'
            },
            '1': {
            '0': '\(utxo.commitmentYBit.description)',
            '1': '\(utxo.pubkeyYBit.description)',
            '2': '\(utxo.txPubYBit.description)'
            },
            '2': {
            '0': '\(utxo.amount.description)',
            '1': '\(utxo.mask.description)'
            },
            '3': parseInt(\(utxo.index.description)),
            '4': parseInt(\(utxo.txid.description))
            };
            const utxoInstance = new tomoprivacyjs.default.UTXO(utxo);
            const isMine = utxoInstance.checkOwnership('\(privSpendKey)');
            return isMine && isMine.amount ? isMine.amount : null ;
            
            })()
            """)  else{
                return .none
        }
        if js.toString() == "null"{
            return .none
        }
        return js.toString()
    }
    
    func getkeyImage(utxos: [UTXO], pk: String) -> Array<UInt8>?   {
        var utxos_String = ""
        for utxo in utxos{
            utxos_String.append("""
                {
                '0': {
                '0': '\(utxo.commitmentX.description)',
                '1': '\(utxo.pubkeyX.description)',
                '2': '\(utxo.txPubX.description)'
                },
                '1': {
                '0': '\(utxo.commitmentYBit.description)',
                '1': '\(utxo.pubkeyYBit.description)',
                '2': '\(utxo.txPubYBit.description)'
                },
                '2': {
                '0': '\(utxo.amount.description)',
                '1': '\(utxo.mask.description)'
                },
                '3': parseInt(\(utxo.index.description)),
                '4': parseInt(\(utxo.txid.description))
                },
                """)
        }
        utxos_String = String(utxos_String.dropLast())
        guard let js = context?.evaluateScript(
            """
            (function(){
            const rawUtxos = [\(utxos_String)];
            return tomoprivacyjs.default.Wallet.keyImages(rawUtxos, '\(pk)');
            })()
            """)  else{
                return .none
        }
        return js.toArray() as? Array<UInt8>
    }
    
    func privSpendKey(pk: String) -> String?{
        guard let privSpendKey = context?.evaluateScript(
            """
            (function(){
            const addresses = tomoprivacyjs.default.Address.generateKeys("\(pk)");
            return addresses.privSpendKey
            })()
            """)  else{
                return .none
        }
        return privSpendKey.toString()
    }
    
    func genDepositProof(amount: String, pk: String) -> String? {
        guard let js = context?.evaluateScript(
            """
            (function(){
            let proof = tomoprivacyjs.default.Wallet.genDepositProof("1000000000000000000000", "\(pk)");
            return proof
            })()
            """)  else{
                return .none
        }
        print(js)
        return js.toString()
    }
}
