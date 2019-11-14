//  TermsController.swift

import UIKit

class TermsController: UIViewController,UIWebViewDelegate{
  
  private var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView = UIWebView()
    webView.delegate = self
    webView.frame = self.view.bounds
    self.view.addSubview(webView)
    let url = URL(string: "http://sirube.city/terms.html")!
    let request = URLRequest(url: url as URL)
    webView.loadRequest(request as URLRequest)
    navigationItem.title = "利用規約"
  }
  
}

