//
//  WebViewController.swift
//  NewsFeed
//
//  Created by paytalab on 5/9/24.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKUIDelegate{
    private let urlString: String
    private let titleString: String
    private lazy var webview = {
        let config = WKWebViewConfiguration()
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.uiDelegate = self
        return webview
    }()
    
    init(titleString: String, urlString: String) {
        self.urlString = urlString
        self.titleString = titleString
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleString
        view.addSubview(webview)
        webview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let url = URL(string: urlString) {
            webview.load(URLRequest(url: url))
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
