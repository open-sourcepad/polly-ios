//
//  WebViewController.swift
//  
//
//  Created by Aj Fermin on 29/07/2016.
//
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var urlToOpen: String = ""
    var pollyTitle: String = ""
    
    //MARK: - Lazy variables
    private lazy var webView: UIWebView = {
        let webView: UIWebView = UIWebView(frame: CGRectMake(0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT))
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
        webView.scrollView.setContentOffset(CGPointZero, animated: true)
        return webView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingIndicator.center = self.view.center
        loadingIndicator.color = COLOR_POLLY_PINK
        loadingIndicator.hidesWhenStopped = true
        return loadingIndicator
    }()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlToOpen)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private methods
    func configureView() {
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = pollyTitle
        
        self.view.addSubview(webView)
        self.view.addSubview(loadingIndicator)
    }
    
    //MARK: Webview Delegate
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let alert = UIAlertController(title: "Cannot load webpage", message: error?.localizedDescription, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true) { 
            self.loadingIndicator.stopAnimating()
        }
        print("Failed to load webview \(error?.description)")
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingIndicator.stopAnimating()
    }
}