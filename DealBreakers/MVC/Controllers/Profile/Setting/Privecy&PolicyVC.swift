//
//  Privecy&PolicyVC.swift
//  DealBreakers
//
//  Created by Vivek Dharmani on 5/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit

class Privecy_PolicyVC: UIViewController , WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL (string: Constant.shared.baseUrl+Constant.shared.policy)
        let request = URLRequest(url: url!)
        webView.load(request)
        self.webView.navigationDelegate = self
        IJProgressView.shared.showProgressView()
        // Do any additional setup after loading the view.
    }

    @IBAction func backButonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        IJProgressView.shared.hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        IJProgressView.shared.hideProgressView()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        IJProgressView.shared.hideProgressView()
    }
}
