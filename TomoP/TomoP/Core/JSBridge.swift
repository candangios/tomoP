//
//  JSBridge.swift
//  TomoP
//
//  Created by CanDang on 12/11/20.
//  Copyright © 2020 CanDang. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import WebKit
import PromiseKit


class JSBridge: NSObject {
    private var webView = WKWebView()
    override init(){
        let filepath = Bundle.main.path(forResource: "index", ofType: "js")!
                super.init()
                let jsSource = try! String(contentsOfFile: filepath)
                let config = WKWebViewConfiguration()
                let jsScript = WKUserScript(source: jsSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                config.userContentController.addUserScript(jsScript)
                self.webView = WKWebView(frame: .zero, configuration: config)
                self.webView.navigationDelegate = self
        print(self.webView.navigationDelegate)
        
    }
    
    func checkOwnership(utxo: UTXO,privSpendKey: String) -> String?   {
        return .none
//        guard let js = context?.evaluateScript(
//            """
//            (function(){
//            const utxo = {
//            '0': {
//            '0': '\(utxo.commitmentX.description)',
//            '1': '\(utxo.pubkeyX.description)',
//            '2': '\(utxo.txPubX.description)'
//            },
//            '1': {
//            '0': '\(utxo.commitmentYBit.description)',
//            '1': '\(utxo.pubkeyYBit.description)',
//            '2': '\(utxo.txPubYBit.description)'
//            },
//            '2': {
//            '0': '\(utxo.amount.description)',
//            '1': '\(utxo.mask.description)'
//            },
//            '3': parseInt(\(utxo.index.description)),
//            '4': parseInt(\(utxo.txid.description))
//            };
//            const utxoInstance = new tomoprivacyjs.default.UTXO(utxo);
//            const isMine = utxoInstance.checkOwnership('\(privSpendKey)');
//            return isMine && isMine.amount ? isMine.amount : null ;
//
//            })()
//            """)  else{
//                return .none
//        }
//        if js.toString() == "null"{
//            return .none
//        }
//        return js.toString()
    }
    
    func getkeyImage(utxos: [UTXO], pk: String) -> Array<UInt8>?   {
        return .none
//        var utxos_String = ""
//        for utxo in utxos{
//            utxos_String.append("""
//                {
//                '0': {
//                '0': '\(utxo.commitmentX.description)',
//                '1': '\(utxo.pubkeyX.description)',
//                '2': '\(utxo.txPubX.description)'
//                },
//                '1': {
//                '0': '\(utxo.commitmentYBit.description)',
//                '1': '\(utxo.pubkeyYBit.description)',
//                '2': '\(utxo.txPubYBit.description)'
//                },
//                '2': {
//                '0': '\(utxo.amount.description)',
//                '1': '\(utxo.mask.description)'
//                },
//                '3': parseInt(\(utxo.index.description)),
//                '4': parseInt(\(utxo.txid.description))
//                },
//                """)
//        }
//        utxos_String = String(utxos_String.dropLast())
//        guard let js = context?.evaluateScript(
//            """
//            (function(){
//            const rawUtxos = [\(utxos_String)];
//            return tomoprivacyjs.default.Wallet.keyImages(rawUtxos, '\(pk)');
//            })()
//            """)  else{
//                return .none
//        }
//        return js.toArray() as? Array<UInt8>
    }
    
    func privSpendKey(pk: String) -> String?{
        return .none
//        guard let privSpendKey = context?.evaluateScript(
//            """
//            (function(){
//            const addresses = tomoprivacyjs.default.Address.generateKeys("\(pk)");
//            return addresses.privSpendKey
//            })()
//            """)  else{
//                return .none
//        }
//        return privSpendKey.toString()
    }
    
    func genDepositProof(amount: String, pk: String) -> String? {
        self.webView.evaluateJavaScript("""
        (function(){
          let proof = tomoprivacyjs.default.Wallet.genDepositProof("1000000000000000000000", "\(pk)");
          return proof
        })()
        """) { (data, error) in
            print(data)
        }
        return .none
//        guard let js = context?.evaluateScript(
//            """
//            (function(){
//            })()
//            """)  else{
//                return .none
//        }
//        print(js)
//        return js.toString()
    }
}

extension JSBridge: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let pk = "6378de134e758bd024ccaf0e6d5508f4911ba57d2c1e79d15c099d0d7f285a8d"
        webView.evaluateJavaScript("""
          (function(){
                           let proof = tomoprivacyjs.default.Wallet.genDepositProof("1000000000000000000000", "\(pk)");
                           return proof
            })()
        """) { (data, error) in
            print(data)
        }
        
    }
    
}
