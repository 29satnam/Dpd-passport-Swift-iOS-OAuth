
//
//  ViewController.swift
//  test
//
//  Created by Satnam Sync on 1/26/16.
//  Copyright © 2016 Satnam Sync. All rights reserved.
//

//deployd dpd-passport facebook twitter google OAuth implementation

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    var webView: UIWebView!
    // var currentLoginAttempt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://my.vigasdeep.com:2403/auth/twitter")!))
        webView.delegate = self;
        self.view.addSubview(webView)
        
    }
    //
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("didFailLoadWithError")
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print("\(request.URL!.absoluteString)");
        
        let fullNameArr = request.URL!.absoluteString.characters.split{$0 == "?"}.map(String.init)
        let callbackUrl = fullNameArr[0];
        if callbackUrl  == "http://my.vigasdeep.com:2403/auth/twitter/callback" //change
        {
            webView.stopLoading();
            
            let url = NSURL(string: request.URL!.absoluteString)
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let responsedata = self.convertStringToDictionary(datastring as! String);
                
                print("\(responsedata!["id"])");
                
                print(responsedata!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    webView.removeFromSuperview()
                })
            }
            task.resume()
        }
        
        return true
    }
    func webViewDidStartLoad(webView: UIWebView) {
        
        print("webViewDidStartLoad")
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        print("webViewDidFinishLoad")
        
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}