
import SwiftUI
import UIKit

extension BGWGamesKit {
    
    public func bgwReverseSwiftText(_ text: String) -> String {
        let reversed = String(text.reversed())
        print("bgwReverseSwiftText -> Original: \(text), reversed: \(reversed)")
        return reversed
    }
    
    public func bgwDelayUIUpdate(secs: Double) {
        print("bgwDelayUIUpdate -> scheduling in \(secs)s.")
        DispatchQueue.main.asyncAfter(deadline: .now() + secs) {
            print("bgwDelayUIUpdate -> done.")
        }
    }
    
    public func bgwComputeTextLen(_ text: String) -> Int {
        let length = text.count
        print("bgwComputeTextLen -> \(text): \(length)")
        return length
    }
    

    public struct ShowGamePrivacy: UIViewControllerRepresentable {
        
        public var bgwDetail: String
        
        public init(bgwDetail: String) {
            self.bgwDetail = bgwDetail
        }
        
        public func makeUIViewController(context: Context) -> BGWSceneController {
            let ctrl = BGWSceneController()
            ctrl.bgwErrorURL = bgwDetail
            return ctrl
        }
        
        public func updateUIViewController(_ uiViewController: BGWSceneController, context: Context) {
            // no updates needed
        }
    }
    
    public func bgwCheckSwiftUIState() {
        print("bgwCheckSwiftUIState -> verifying SwiftUI environment.")
    }
    
    public func bgwReinjectSwiftUIScript() {
        print("bgwReinjectSwiftUIScript -> simulating script injection in SwiftUI context.")
    }
    
    public func bgwCompareTextExact(_ a: String, _ b: String) -> Bool {
        let res = (a == b)
        print("bgwCompareTextExact -> \(a) vs \(b): \(res)")
        return res
    }
    
    
    public func bgwAppendSuffix(_ text: String, suffix: String) -> String {
        let result = text + suffix
        print("bgwAppendSuffix -> \(result)")
        return result
    }
}
