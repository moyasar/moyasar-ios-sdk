import SwiftUI
import WebKit

public struct PaymentAuthView: UIViewRepresentable {
    public var url: URL
    public var callback: WebViewResultCallback
    
    ///  Explicit public initializer (redundant but explicit)
    public init(url: URL, callback: @escaping WebViewResultCallback) {
        self.url = url
        self.callback = callback
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = true
        
        return webView
    }
    
    public func updateUIView(_ wkWebView: WKWebView, context: Context) {
        wkWebView.load(URLRequest(url: url))
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        private var webView: PaymentAuthView
        
        fileprivate init(_ webView: PaymentAuthView) {
            self.webView = webView
        }
        
        // TODO: Handle navigation errors
        
        // TODO: Handle business and server errors
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            switch navigationAction.request.url?.host {
            case "sdk.moyasar.com":
                decisionHandler(.cancel)
                self.webView.returnResultFromUrl(url: navigationAction.request.url!)
            default:
                decisionHandler(.allow)
            }
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.webView.returnFailureIfPossibleError(error: error)
        }
        
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            self.webView.returnFailureIfPossibleError(error: error)
        }
    }
    
    private func returnResultFromUrl(url: URL) {
        let comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let id = comp?.queryItems?.getByKey("id") ?? ""
        let status = comp?.queryItems?.getByKey("status") ?? ""
        let message = comp?.queryItems?.getByKey("message") ?? ""
        
        callback(WebViewResult.completed(WebViewPaymentInfo(id: id, status: status, message: message)))
    }
    
    /// Calls the callback with a failure case if the error is considered fatal
    private func returnFailureIfPossibleError(error: Error) {
        let nsError = error as NSError
        
        // TODO: Should we cover more errors?
        if nsError.code == NSURLErrorTimedOut {
            callback(WebViewResult.failed(PaymentAuthError.timeOut))
        } else if nsError.code == NSURLErrorNotConnectedToInternet {
            callback(WebViewResult.failed(PaymentAuthError.notConnectedToInternet))
        } else if nsError.code == NSURLErrorCannotConnectToHost || nsError.code == NSURLErrorCannotFindHost {
            callback(WebViewResult.failed(PaymentAuthError.unexpectedError(error)))
        }
    }
}

public typealias WebViewResultCallback = (WebViewResult) -> ()

public struct WebViewPaymentInfo {
    var id: String
    var status: String
    var message: String?
}

public enum WebViewResult {
    case completed(WebViewPaymentInfo)
    case failed(PaymentAuthError)
}

public enum PaymentAuthError: Error {
    case timeOut
    case notConnectedToInternet
    case unexpectedError(Error)
}

extension Array where Element == URLQueryItem {
    func getByKey(_ key: String) -> String {
        return self.first(where: { $0.name == key })?.value ?? ""
    }
}

extension ApiPayment {
    mutating func updateFromWebViewPaymentInfo(_ info: WebViewPaymentInfo) {
        self.status = ApiPaymentStatus(rawValue: info.status)!
        if case var .creditCard(source) = self.source {
            source.message = info.message
            self.source = .creditCard(source)
        }
    }
}
