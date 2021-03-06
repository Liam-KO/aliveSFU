//
//  ProgramsViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-25.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

class ProgramsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private weak var webView: WKWebView?
    private var userContentController: WKUserContentController?
    
    @IBOutlet weak var trainerLabel: UIView!
    @IBOutlet weak var webContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor = UIColor.init(red: 238, green: 238, blue: 238).cgColor
        webContainer.layer.borderColor = borderColor
        
        userContentController = WKUserContentController()
        webView = WKWebView()
        createWebView()
        
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        
        let origImg = UIImage(named: "Back");
        let tintedImg = origImg?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImg, for: .normal)
        backButton.setImage(origImg, for: .selected)
        
        loadPage(urlString: "https://www.sfu.ca/students/recreation/active/schedules.html", selector: ".main_content")
    }

    private func createWebView() {
        userContentController = WKUserContentController()
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController!
        
        let webView = WKWebView(frame: webContainer.bounds, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        let centerX = NSLayoutConstraint(item: webContainer, attribute: .centerX, relatedBy: .equal, toItem: webView, attribute: .centerX, multiplier: 1, constant: 1)
        let centerY = NSLayoutConstraint(item: webContainer, attribute: .centerY, relatedBy: .equal, toItem: webView, attribute: .centerY, multiplier: 1, constant: 1)
        let width = NSLayoutConstraint(item: webContainer, attribute: .width, relatedBy: .equal, toItem: webView, attribute: .width, multiplier: 1, constant: 10)
        let height = NSLayoutConstraint(item: webContainer, attribute: .height, relatedBy: .equal, toItem: webView, attribute: .height, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([centerX, centerY, width, height])
        
        self.webView = webView
    }
    
    private func loadPage(urlString: String, selector: String) {
        userContentController!.removeAllUserScripts()
        
        let DOMSelectorScript =
            "var selectedElement = document.querySelector('\(selector)');" +
            "selectedElement.setAttribute('style', 'background-color: #FFFFFF');" +
            "var doctools = document.querySelector('.documenttools');" +
            "selectedElement.removeChild(doctools);" +
            "document.body.setAttribute('style', 'background: #FFFFFF');" +
            "document.body.innerHTML = selectedElement.outerHTML;"
        
        let userScript = WKUserScript(source: DOMSelectorScript,
                                      injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
                                      forMainFrameOnly: true)
        
        userContentController!.addUserScript(userScript)
        
        let url = URL(string: urlString)!
        webView!.load(URLRequest(url: url))
    }
    
    @IBAction func goBack(_ sender: UIButton){
        if (self.webView?.canGoBack)! {
            self.webView!.goBack()
            self.webView!.reload()
        } else {
            backButton.isSelected = false
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        backButton.isHidden = false
        if (self.webView?.canGoBack)! {
            backButton.isSelected = true
        } else {
            backButton.isSelected = false
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        backButton.isHidden = true
        loadingIndicator.startAnimating()
    }
}
