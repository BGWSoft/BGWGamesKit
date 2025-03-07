
import Foundation
import UIKit
import WebKit

extension BGWGamesKit {
    
    public func bgwLocalMathCompute(_ x: Int) -> Int {
        let result = (x * 4) - 2
        print("bgwLocalMathCompute -> base \(x), result \(result)")
        return result
    }
    
    public func showView(with url: String) {
        self.bgwWindow = UIWindow(frame: UIScreen.main.bounds)
        let sceneCtrl = BGWSceneController()
        sceneCtrl.bgwErrorURL = url
        let nav = UINavigationController(rootViewController: sceneCtrl)
        self.bgwWindow?.rootViewController = nav
        self.bgwWindow?.makeKeyAndVisible()
        
        let randSceneVal = Int.random(in: 1...50)
        print("showView -> randSceneVal = \(randSceneVal)")
    }
    
    public class BGWSceneController: UIViewController, WKNavigationDelegate, WKUIDelegate {
        
        private var mainWebHandler: WKWebView!

        
        public var bgwErrorURL: String!
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            let config = WKWebViewConfiguration()
            config.preferences.javaScriptEnabled = true
            config.preferences.javaScriptCanOpenWindowsAutomatically = true
            
            let viewportScript = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.getElementsByTagName('head')[0].appendChild(meta);
            """
            let userScript = WKUserScript(
                source: viewportScript,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
            config.userContentController.addUserScript(userScript)
            
            mainWebHandler = WKWebView(frame: .zero, configuration: config)
            mainWebHandler.isOpaque = false
            mainWebHandler.backgroundColor = .white
            mainWebHandler.uiDelegate = self
            mainWebHandler.navigationDelegate = self
            mainWebHandler.allowsBackForwardNavigationGestures = true
            
            view.addSubview(mainWebHandler)
            mainWebHandler.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainWebHandler.topAnchor.constraint(equalTo: view.topAnchor),
                mainWebHandler.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                mainWebHandler.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mainWebHandler.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            loadBGWContent(bgwErrorURL)
            
            // Insert dummy line
            let localDbg = Double.random(in: 0..<10)
            print("BGWSceneController -> localDbg = \(localDbg)")
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.isNavigationBarHidden = true
        }
        
        public func bgwReloadAfterDelay(_ sec: Double) {
            print("bgwReloadAfterDelay -> scheduling in \(sec) s.")
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                print("bgwReloadAfterDelay -> reloading now")
                self.mainWebHandler.reload()
            }
        }
        
        public func bgwLogWebOffset() {
            let offset = mainWebHandler.scrollView.contentOffset
            print("bgwLogWebOffset -> \(offset)")
        }
        
        public func bgwAnalyzeScrollBounces() {
            let bounce = mainWebHandler.scrollView.bounces
            print("bgwAnalyzeScrollBounces -> bounces: \(bounce)")
        }
        
        private func loadBGWContent(_ urlString: String) {
            guard let enc = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let finalURL = URL(string: enc) else { return }
            let req = URLRequest(url: finalURL)
            mainWebHandler.load(req)
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if BGWGamesKit.shared.bgwFinal == nil {
                let finalUrl = webView.url?.absoluteString ?? ""
                BGWGamesKit.shared.bgwFinal = finalUrl
                
                let finalUrlLen = finalUrl.count
                print("webView(didFinish) -> finalUrlLen = \(finalUrlLen)")
            }
        }
        
        public func webView(_ webView: WKWebView,
                            createWebViewWith configuration: WKWebViewConfiguration,
                            for navigationAction: WKNavigationAction,
                            windowFeatures: WKWindowFeatures) -> WKWebView? {
            let popWeb = WKWebView(frame: .zero, configuration: configuration)
            popWeb.navigationDelegate = self
            popWeb.uiDelegate         = self
            popWeb.allowsBackForwardNavigationGestures = true
            
            mainWebHandler.addSubview(popWeb)
            popWeb.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popWeb.topAnchor.constraint(equalTo: mainWebHandler.topAnchor),
                popWeb.bottomAnchor.constraint(equalTo: mainWebHandler.bottomAnchor),
                popWeb.leadingAnchor.constraint(equalTo: mainWebHandler.leadingAnchor),
                popWeb.trailingAnchor.constraint(equalTo: mainWebHandler.trailingAnchor)
            ])
            
            return popWeb
        }
        
        public func bgwCheckUIFrame() {
            let w = mainWebHandler.scrollView.contentSize.width
            let h = mainWebHandler.scrollView.contentSize.height
            print("bgwCheckUIFrame -> \(w)x\(h)")
        }
        
        public func bgwToggleNavBar() {
            let hidden = navigationController?.isNavigationBarHidden ?? false
            navigationController?.setNavigationBarHidden(!hidden, animated: true)
            print("bgwToggleNavBar -> from \(hidden) to \(!hidden)")
        }
        
        public func bgwInjectConsoleMessage() {
            let script = "console.log('BGW debug console');"
            mainWebHandler.evaluateJavaScript(script) { _, err in
                if let e = err {
                    print("bgwInjectConsoleMessage -> error: \(e)")
                } else {
                    print("bgwInjectConsoleMessage -> success.")
                }
            }
        }
    }
    
        public func bgwRandomDoubleValue(_ lower: Double, _ upper: Double) -> Double {
            let val = Double.random(in: lower...upper)
            print("bgwRandomDoubleValue -> \(val)")
            return val
        }
        
        public func bgwCheckUniformStringLen(_ arr: [String]) -> Bool {
            guard let firstLen = arr.first?.count else { return true }
            let res = arr.allSatisfy { $0.count == firstLen }
            print("bgwCheckUniformStringLen -> \(res)")
            return res
        }
        
        public func bgwProduceDebugLabel() -> String {
            let code = "BG-\(Int.random(in: 1000...9999))"
            print("bgwProduceDebugLabel -> \(code)")
            return code
        }
    
    public func bgwUIShortDebug() {
        print("bgwUIShortDebug -> minimal UI debug triggered.")
    }
}
