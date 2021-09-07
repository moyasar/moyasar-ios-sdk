import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
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
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }
    
    func updateUIView(_ wkWebView: WKWebView, context: Context) {
        wkWebView.load(URLRequest(url: url))
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var webView: WebView
        
        internal init(_ webView: WebView) {
            self.webView = webView
        }
        
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
