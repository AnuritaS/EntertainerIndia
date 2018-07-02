//
//  WebViewVC.swift
//  Entertainer
//
//  Created by Nikhil Bansal on 01/03/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController,WKNavigationDelegate, WKUIDelegate{
    
    var activityIndicator: UIActivityIndicatorView!
    var label: UILabel!
    var webView: WKWebView!
    var frameName=String()
    var url=String()
    
    
    @IBOutlet weak var frameNameLbl: UILabel!
    @IBOutlet weak var toolbar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        frameNameLbl.text=frameName
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame:
            CGRect(x: 0, y: 72, width: self.view.frame.size.width, height: self.view.frame.size.height-72), configuration: webViewConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor.white
        
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
      
    }
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
