//
//  TargetViewController.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import UIKit
import WebKit

class TargetViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func setupSubviews() {
        webView.allowsBackForwardNavigationGestures = true
        
        let request = URLRequest(urlString: "https://github.com/sacredsoul/Secrets/blob/main/%E5%87%8F%E8%84%82.md")
        webView.load(request!)
    }
}

