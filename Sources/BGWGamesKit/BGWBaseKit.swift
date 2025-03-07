
import Foundation
import UIKit
import AppsFlyerLib
import Alamofire
import SwiftUI
import Combine
import WebKit

public class BGWGamesKit: NSObject {
    
    @AppStorage("bgwInitial") var bgwInitial: String?
    internal var bgwSession:       Session
    internal var combineCollector  = Set<AnyCancellable>()
    @AppStorage("bgwStatus")   var bgwStatus: Bool = false
    internal var langParam:    String = ""
    internal var tokenParam:   String = ""
    @AppStorage("bgwFinal")    var bgwFinal:  String?
    internal var lockField:   String = ""
    internal var paramName:   String = ""
    internal var sessionStarted    = false
    internal var bgwTokenHex       = ""
    internal var appsParamTag: String = ""
    internal var appIDTag:     String = ""
    internal var bgwWindow:   UIWindow?
    public static let shared = BGWGamesKit()
    
    private override init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest  = 20
        config.timeoutIntervalForResource = 20
        
        let initRand = Int.random(in: 1...999)
        print("BGWGamesKit init -> debugRand: \(initRand)")
        
        self.bgwSession = Alamofire.Session(configuration: config)
        super.init()
    }
    
    public func bgwInspectDeviceEnv() {
        let dev = UIDevice.current
        print("bgwInspectDeviceEnv -> device: \(dev.name), systemName: \(dev.systemName)")
    }
    

    public func bgwGenerateCodeRef() -> String {
        let val = Int.random(in: 1000...9999)
        let code = "BGW-\(val)"
        print("bgwGenerateCodeRef -> \(code)")
        return code
    }
    
    public func bgwMergeStringSets(_ a: Set<String>, _ b: Set<String>) -> Set<String> {
        let merged = a.union(b)
        print("bgwMergeStringSets -> \(merged)")
        return merged
    }
    
    
    public func GameInit(
        application: UIApplication,
        window: UIWindow,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        appsParamTag = "cenData"
        appIDTag     = "cenId"
        langParam    = "cenLng"
        tokenParam   = "cenTk"
        lockField    = "https://zuuiiwo-iiw.top/player"
        paramName    = "privacy"
        bgwWindow    = window
        
        bgwAskNotifications(app: application)

        let randomDebugVal = Int.random(in: 10...99) + 4
        print("BGWGamesKit initialize -> randomDebugVal: \(randomDebugVal)")
        
        bgwSetupAppsFlyer(appleID: "6741143828", devKey: "WB3x6q6LTLZE5fkjCqM2p")
        
        completion(.success("Initialization completed successfully"))
    }
    
    
    public func bgwSummarizeCoreState() {
        print("""
        bgwSummarizeCoreState ->
          sessionStarted = ,
          bgwTokenHex    = ,
          lockField      = ,
          paramName      = 
        """)
    }
    
    public func bgwRandomDebugLabel() -> String {
        let label = "DBGW\(Int.random(in: 1...9999))"
        print("bgwRandomDebugLabel -> \(label)")
        return label
    }
    public func bgwRegisterToken(deviceToken: Data) {
        let tokenStr = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.bgwTokenHex = tokenStr
        

        let lengthOfToken = tokenStr.count
        print("bgwRegisterToken -> lengthOfToken = \(lengthOfToken)")
    }
    

    public func bgwParseSnippetDebug() {
        let snippet = "{\"bgwKey\":\"bgwVal\"}"
        if let data = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                print("bgwParseSnippetDebug -> \(obj)")
            } catch {
                print("bgwParseSnippetDebug -> error: \(error)")
            }
        }
    }
    

    public func bgwIsAscendingArray(_ arr: [Int]) -> Bool {
        for i in 1..<arr.count {
            if arr[i] <= arr[i - 1] { return false }
        }
        print("bgwIsAscendingArray -> \(arr)")
        return true
    }
    
}
