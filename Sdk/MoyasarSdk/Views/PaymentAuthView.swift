import SwiftUI
import WebKit

struct PaymentAuthView: UIViewRepresentable {
    var url: URL
    var callback: WebViewResultCallback
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = true
        
        return webView
    }
    
    func updateUIView(_ wkWebView: WKWebView, context: Context) {
        wkWebView.load(URLRequest(url: url))
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var webView: PaymentAuthView
        
        internal init(_ webView: PaymentAuthView) {
            self.webView = webView
        }
        
        // Handle internet outage
        
        // Handle navigation errors
        
        // Handle business and server errors
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            switch navigationAction.request.url?.host {
                case "sdk.moyasar.com":
                    decisionHandler(.cancel)
                    self.webView.returnResultFromUrl(url: navigationAction.request.url!)
                default:
                    decisionHandler(.allow)
            }
        }
    }
    
    func returnResultFromUrl(url: URL) {
        let comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let id = comp?.queryItems?.getByKey("id") ?? ""
        let status = comp?.queryItems?.getByKey("status") ?? ""
        let message = comp?.queryItems?.getByKey("message") ?? ""
        
        callback(WebViewResult.completed(WebViewPaymentInfo(id: id, status: status, message: message)))
    }
}

typealias WebViewResultCallback = (_: WebViewResult) -> ()

struct WebViewPaymentInfo {
    var id: String
    var status: String
    var message: String?
}

enum WebViewResult {
    case completed(WebViewPaymentInfo)
    case failed(Error)
}

extension Array where Element == URLQueryItem {
    func getByKey(_ key: String) -> String {
        return self.first(where: { $0.name == key })?.value ?? ""
    }
}

extension ApiPayment {
    mutating func updateFromWebViewPaymentInfo(_ info: WebViewPaymentInfo) {
        self.status = info.status
        if case var .creditCard(source) = self.source {
            source.message = info.message
        }
    }
}
