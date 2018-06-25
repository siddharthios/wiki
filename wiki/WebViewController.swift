//
//  WebViewController.swift
//  wiki
//
//  Created by Siddharth Kumar on 25/06/18.
//  Copyright © 2018 Siddharth Kumar. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var apiString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let webView = UIWebView(frame: UIScreen.main.bounds)
        webView.delegate = self
        view.addSubview(webView)
        if let url = URL(string: apiString) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
