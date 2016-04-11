//
//  EventDetailViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/31/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import WebKit

class EventDetailViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var recognizedText:String!
    var webView: WKWebView!
    var contentController: WKUserContentController!
    var config: WKWebViewConfiguration!
    
    @IBOutlet weak var webViewContainer: UIView!
    
    override func loadView() {
        super.loadView()
        contentController = WKUserContentController()
        config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: webViewContainer.bounds,
                            configuration: config)
        webView.navigationDelegate = self
        webViewContainer.addSubview(webView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Inside EventDetailViewController: \(recognizedText)")
        let url = NSURL(string: "https://www.google.com/")!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        
        webView.evaluateJavaScript("alert('Hi!')") { (result: AnyObject?, error: NSError?) in
            if result != nil {
                print(result)
            }
            else {
                print("error: \(error?.localizedDescription)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            print("Javascript is sending a message: \(message.body)");
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
