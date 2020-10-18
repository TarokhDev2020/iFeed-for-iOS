//
//  WebController.swift
//  iFeed
//
//  Created by Tarokh on 8/21/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet var webView: WKWebView!
    
    
    //MARK: - Variables
    var htmlURL: String?
    var progressView: UIProgressView?

    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView = UIProgressView(progressViewStyle: .default)
        progressView!.sizeToFit()
        
        print("The url is: \(htmlURL!)")
        
        webView.load(NSURLRequest(url: NSURL(string: htmlURL!)! as URL) as URLRequest)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    //MARK: - Functions
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView!.progress = Float(webView.estimatedProgress)
        }
    }

}
