//
//  NewsDetails.swift
//  PLAYO iOS Assignment
//
//  Created by Sourav Bhattacharjee on 09/08/22.
//

import UIKit
import WebKit

class NewsDetails: UIViewController, WKUIDelegate, WKNavigationDelegate{

    var newsUrl = ""
    
    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        newsWebView.navigationDelegate = self
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        
        guard let url = URL(string: newsUrl) else {
            print("Invalid News Url")
            return
        }
        
        newsWebView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didCommit  navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
}
