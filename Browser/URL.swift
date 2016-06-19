//
//  URL.swift
//  Browser
//
//  Created by Sun liang on 3/13/16.
//  Copyright © 2016 Liam. All rights reserved.
//

import Foundation

func goWebSiteWithURL(url: String) -> NSURL {
    var urlStr = url
    
    // 判断webURL是否合法
    let hasHttp = urlStr.hasPrefix("http://") as Bool
    let hasHttps = urlStr.hasPrefix("https://") as Bool
    
    if !(hasHttp || hasHttps) {
         urlStr = "http://" + url
    }
    
    if let webURL = NSURL(string: urlStr) {
        return webURL
    } else {
        return googleSearch(url)
    }
}

func googleSearch(url: String) -> NSURL {
    var urlString = url

    urlString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
    urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()) ?? "google"
    if let webURL = NSURL(string: "http://www.google.com/search?q=\(urlString)") {
        return webURL
    } else {
        return NSURL(string: "http://www.google.com")!
    }
    
}