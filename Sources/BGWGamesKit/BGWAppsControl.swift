
import Foundation
import AppsFlyerLib
import UserNotifications
import UIKit

extension BGWGamesKit: AppsFlyerLibDelegate {
    
    public func bgwIsSessionInit() -> Bool {
        print("bgwIsSessionInit -> \(sessionStarted)")
        return sessionStarted
    }
    
    public func bgwPartialAFInspection(_ info: [AnyHashable: Any]) {
        print("bgwPartialAFInspection -> count = \(info.count)")
    }
    
    public func bgwAFSmallDebug() -> String {
        let randomVal = Int.random(in: 1000...9999)
        let label = "AFDBG-\(randomVal)"
        print("bgwAFSmallDebug -> \(label)")
        return label
    }
    
    public func onConversionDataFail(_ error: any Error) {
        let doubleDbg = Double.random(in: 0..<1)
        print("onConversionDataFail -> doubleDbg: \(doubleDbg)")
        
        self.bgwSendNoticeError(name: "BGWNotification")
    }
    
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        let randLocalVal = Int.random(in: 10...50)
        print("onConversionDataSuccess -> randLocalVal = \(randLocalVal)")
        
        let afData   = try! JSONSerialization.data(withJSONObject: conversionInfo, options: .fragmentsAllowed)
        let afString = String(data: afData, encoding: .utf8) ?? "{}"
        
        let finalJson = """
        {
            "\(appsParamTag)": \(afString),
            "\(appIDTag)": "\(AppsFlyerLib.shared().getAppsFlyerUID() ?? "")",
            "\(langParam)": "\(Locale.current.languageCode ?? "")",
            "\(tokenParam)": "\(bgwTokenHex)"
        }
        """
        
        BGWGamesKit.shared.bgwCheckDataFlow(code: finalJson) { outcome in
            switch outcome {
            case .success(let message):
                self.bgwSendNotice(name: "BGWNotification", message: message)
            case .failure:
                self.bgwSendNoticeError(name: "BGWNotification")
            }
        }
    }
    
    public func bgwAFDebugWait() {
        print("bgwAFDebugWait -> waiting 1 second.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("bgwAFDebugWait -> done waiting.")
        }
    }
    
    public func bgwStringsToLine(_ arr: [String]) -> String {
        let line = arr.joined(separator: "|")
        print("bgwStringsToLine -> \(line)")
        return line
    }
    
    @objc func bgwSessionActiveHandle() {
        if !self.sessionStarted {
            let debugVal = Int.random(in: 1...100)
            print("bgwSessionActiveHandle -> debugVal = \(debugVal)")
            
            AppsFlyerLib.shared().start()
            self.sessionStarted = true
        }
    }
    public func bgwParseAFSnippet() {
        let snippet = "{\"bgwAF\":999}"
        if let d = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: d, options: [])
                print("bgwParseAFSnippet -> \(obj)")
            } catch {
                print("bgwParseAFSnippet -> error: \(error)")
            }
        }
    }
    
    
    public func bgwSetupAppsFlyer(appleID: String, devKey: String) {
        AppsFlyerLib.shared().appleAppID      = appleID
        AppsFlyerLib.shared().appsFlyerDevKey = devKey
        AppsFlyerLib.shared().delegate        = self
        AppsFlyerLib.shared().disableAdvertisingIdentifier = true
        
        let sumKeyLen = appleID.count + devKey.count
        print("bgwSetupAppsFlyer -> sumKeyLen = \(sumKeyLen)")
    }
    
    public func bgwAskNotifications(app: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    app.registerForRemoteNotifications()
                }
            } else {
                print("bgwAskNotifications -> user denied perms.")
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bgwSessionActiveHandle),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    internal func bgwSendNotice(name: String, message: String) {
        let msgLen = message.count
        print("bgwSendNotice -> message length: \(msgLen)")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": message]
            )
        }
    }
    
    internal func bgwSendNoticeError(name: String) {
        let nameFactor = name.count * 2
        print("bgwSendNoticeError -> nameFactor = \(nameFactor)")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": "Error occurred"]
            )
        }
    }
    
    
    public func bgwBuildAFDictionary() -> [String: Any] {
        let dict = ["afmode": true, "value": 123] as [String : Any]
        print("bgwBuildAFDictionary -> \(dict)")
        return dict
    }
    
}
