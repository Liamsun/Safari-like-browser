//
//  BrowserViewController.swift
//  Browser
//
//  Created by Sun liang on 3/6/16.
//  Copyright © 2016 Liam. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var searchField: CustomTextField!
    private var reloadBtn: UIButton!
    private var stopBtn: UIButton!
    private var cancelBtn: UIBarButtonItem?

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add WebView
        addWebView()
        
        // add SearchBar
        addSearchField()
        
        // set ProgressBar
        addProgressBar()
        
        // add ToolBar
        addToolBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Set searchField Text
        if let text = webView.URL?.host {
            searchField.text = text
        }
        
        // Add observer
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            if progress < 1.0 {
                progressView.setProgress(progress, animated: true)
            } else {
                progressView.setProgress(0.0, animated: false)
            }
            
//            let currentProgress = webView.estimatedProgress < 1.0 ? webView.estimatedProgress : 0.0
//            progressView.setProgress(Float(currentProgress), animated: true)
//        } else if keyPath == "loading" {
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
//            if webView.loading {
//                navigationController?.navigationBar.addSubview(progressView)
//                if boolForButton.boolValue {
//                    rightButton.setImage(UIImage(named: "delete-icon-white"), forState: .Normal)
//                    boolForButton = false
//                }
//            } else {
//                progressView.removeFromSuperview()
//                if !boolForButton {
//                    rightButton.setImage(UIImage(named: "refresh-icon-white"), forState: .Normal)
//                    boolForButton = true
//                }
//            }
        }
    }
    
    // MARK: Add Some Views
    func addWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        webView.navigationDelegate = self
    }
    
    func addSearchField() {
        navigationController?.navigationBar.barStyle = .BlackTranslucent

        let frame = navigationController?.navigationBar.frame
        searchField = CustomTextField(frame: CGRectMake(0,0,frame!.size.width,frame!.size.height-15))
        searchField.borderStyle = .RoundedRect
        searchField.leftViewMode = .Always
        searchField.textAlignment = .Center
        searchField.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        searchField.attributedPlaceholder = NSAttributedString(string: "Search or enter website name", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        searchField.backgroundColor = UIColor.lightGrayColor()
        searchField.tintColor = UIColor.whiteColor()
        searchField.textColor = UIColor.whiteColor()
        searchField.clearButtonMode = .WhileEditing
        searchField.returnKeyType = .Go
        searchField.enablesReturnKeyAutomatically = true
        searchField.clearsOnBeginEditing = false
        searchField.autocapitalizationType = .None
        searchField.autocorrectionType = .No
        
        
        
        //let height = searchField.frame.height - 10
        //print("\(height)")
        
        //let edgeInset = UIEdgeInsetsMake(height/4, height/4, height/4, height/4)
        
        reloadBtn = UIButton()//frame: CGRectMake(0, 0, height, height))
        //reloadBtn.imageEdgeInsets = edgeInset
        reloadBtn.setImage(UIImage(named: "refresh-icon-white"), forState: .Normal)
        reloadBtn.tintColor = UIColor.whiteColor()
        reloadBtn.addTarget(self, action: #selector(BrowserViewController.onClickReload), forControlEvents: .TouchUpInside)
        
        stopBtn = UIButton()//frame: CGRectMake(0, 0, height, height))
        //stopBtn.imageEdgeInsets = edgeInset
        stopBtn.setImage(UIImage(named: "delete-icon-white"), forState: .Normal)
        stopBtn.tintColor = UIColor.whiteColor()
        stopBtn.addTarget(self, action: #selector(BrowserViewController.onClickStop), forControlEvents: .TouchUpInside)
        
        searchField.rightViewMode = .UnlessEditing
        
        searchField.delegate = self
        
        navigationItem.titleView = searchField

        cancelBtn = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(BrowserViewController.onClickCancel))
        cancelBtn?.tintColor = UIColor.whiteColor()
        
        
    }
    
    func addToolBar() {
        let backwardButtonItem = UIBarButtonItem(image: UIImage(named: "backward"), style: .Plain, target: self, action: #selector(BrowserViewController.onClickBackward))
        let forwardButtonItem = UIBarButtonItem(image: UIImage(named: "forward"), style: .Plain, target: self, action: #selector(BrowserViewController.onClickForward))
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(BrowserViewController.onClickshare))
        let bookmarkButtonItem = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(BrowserViewController.onClickBookmark))
        let tabButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(BrowserViewController.onClickTab))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let toolBar = navigationController?.toolbar
        toolBar?.barStyle = .BlackTranslucent
        toolBar?.tintColor = UIColor.whiteColor()
        self.toolbarItems = [backwardButtonItem,flexibleSpace,forwardButtonItem,flexibleSpace,shareButtonItem,flexibleSpace,bookmarkButtonItem,flexibleSpace,tabButtonItem]
        navigationController?.setToolbarHidden(false, animated: false)
        
    }
    
    func addProgressBar() {
        let frame = CGRectMake(0, self.navigationController!.navigationBar.frame.size.height - 3, self.view.frame.size.width, 8)
        progressView = UIProgressView(frame: frame)
        progressView.progressViewStyle = .Bar
        progressView.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.addSubview(progressView)
    }
    
    // MARK: delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        navigationItem.setRightBarButtonItem(cancelBtn, animated: true)
        textField.textAlignment = .Left
        textField.text = webView?.URL?.absoluteString
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        navigationItem.setRightBarButtonItem(nil, animated: true)
        searchField.resignFirstResponder()
        let webURL = goWebSiteWithURL(textField.text!)
        let request = NSURLRequest(URL: webURL)
        webView.loadRequest(request)
        return true
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        progressView.progress = 0.0
        //searchField.rightView = stopBtn
        searchField.leftView = stopBtn
        let rightView = searchField.rightView
        print("stop size is \(rightView?.frame.width), \(rightView?.frame.height)")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        searchField.text = webView.URL?.host
        searchField.textAlignment = .Center
        //searchField.rightView = reloadBtn
        searchField.leftView = reloadBtn
        let rightView = searchField.rightView
        print("reload size is \(rightView?.frame.width), \(rightView?.frame.height)")

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        if let text = searchField.text {
            let webURL = googleSearch(text)
            let request = NSURLRequest(URL: webURL)
            webView.loadRequest(request)
        }
    }

    // MARK: Private function
//    func onClickRightButton(button: UIButton) {
//       // boolForButton = !boolForButton
//        if !boolForButton {
//            rightButton.setImage(UIImage(named: "delete-icon-white"), forState: .Normal)
//            webView.reload()
//        } else {
//            rightButton.setImage(UIImage(named: "refresh-icon-white"), forState: .Normal)
//            if webView.loading {
//                webView.stopLoading()
//            }
//            
//        }
//    }
//    
    func onClickReload() {
        webView.reload()
    }
    
    func onClickStop() {
        webView.stopLoading()
    }
    
    func onClickForward() {
        webView.goForward()
    }
    
    
    func onClickBackward() {
        webView.goBack()
    }
    
    func onClickBookmark() {
        
    }
    
    func onClickshare() {
        let title = webView.title ?? ""
        if let url = webView.URL {
            let activityViewController = UIActivityViewController(activityItems: [title, url], applicationActivities: nil)
            presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    func onClickTab() {
        navigationController?.pushViewController(TabViewController(), animated: false)
    }
    
    func onClickCancel() {
        searchField.endEditing(true)
        searchField.text = webView.URL?.host ?? ""
        searchField.textAlignment = .Center
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    

}

class CustomTextField: UITextField {
    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        let width = bounds.width
        let height = bounds.height
        return CGRectMake(width - height, 0, height, height)
    }
}
