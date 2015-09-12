//
//  RakutenAPI.swift
//  library
//
//  Created by ryo on 2015/09/12.
//  Copyright (c) 2015年 ryo. All rights reserved.
//

import Foundation


class RactenAPI{
    //https://app.rakuten.co.jp/services/api/BooksTotal/Search/20130522?format=json&keyword=%E6%9C%AC&booksGenreId=000&isbnjan=9784774142340&applicationId=1030809188517726343
    
    // singleton in Swift 1.2
    static let sharedInstance = RactenAPI()
    
    func getJSONWithISBN(isbn:String) -> NSDictionary!{
        // 通信処理(非同期)
        // https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/13-http/fei-tong-qihttp
        
        // 通信処理(同期)
        let api = "https://app.rakuten.co.jp/services/api/BooksTotal/Search/20130522"
        let format = "json"
        let keyword = "%E6%9C%AC"
        let booksGenreId = "000"
        let applicationId = "1030809188517726343"
        let urlString = "\(api)?format=\(format)&keyword=\(keyword)&booksGenreId=\(booksGenreId)&isbnjan=\(isbn)&applicationId=\(applicationId)"
        
        var url = NSURL(string:urlString)!
        // リクエストを生成
        var request = NSURLRequest(URL: url)
        // 送信処理を始める
        var data:NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        
        if data != nil{
            var dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            return dict
            
        }else{
            return nil
        }
    }
    
}