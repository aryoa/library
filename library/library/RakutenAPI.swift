//
//  rakutenAPI.swift
//  library
//
//  Created by HIROKI YAMAMOTO on 2015/08/22.
//  Copyright (c) 2015年 arao. All rights reserved.
//

import Foundation

class RactenAPI{
    //https://app.rakuten.co.jp/services/api/BooksTotal/Search/20130522?format=json&keyword=%E6%9C%AC&booksGenreId=000&isbnjan=9784774142340&applicationId=1030809188517726343
    
    var isbn: String
    init(isbn: String){
        self.isbn = isbn
    }
    
    func getJSONWithISBN() -> Bool{
        // 通信処理
        // https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/13-http/fei-tong-qihttp
        
        // 通信先のURLを生成.
        var myUrl:NSURL = NSURL(string:"https://app.rakuten.co.jp/services/api/BooksTotal/Search/20130522?format=json&keyword=%E6%9C%AC&booksGenreId=000&isbnjan=9784774142340&applicationId=1030809188517726343")!
        // リクエストを生成.
        var myRequest:NSURLRequest  = NSURLRequest(URL: myUrl)
        // 送信処理を始める.
        NSURLConnection.sendAsynchronousRequest(myRequest, queue: NSOperationQueue.mainQueue(), completionHandler: self.getHttp)
        
        return true
    }
    
    func getHttp(res:NSURLResponse?,data:NSData?,error:NSError?){
        if error == nil{
            
            //convert json data to dictionary
            var dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            var items = dict["Items"] as NSArray
            var item = items[0]["Item"] as NSDictionary
            
            println("tile: " + (item["title"] as String))
            println("author: " + (item["author"] as String))
            println("publisherName: " + (item["publisherName"] as String))
            println("itemUrl: " + (item["itemUrl"] as String))
// itemの内容は以下のような感じ
//            "Item": {
//                "title": "かんたんC＃",
//                "author": "伊藤達也",
//                "artistName": "",
//                "publisherName": "技術評論社",
//                "label": "",
//                "isbn": "9784774142340",
//                "jan": "",
//                "hardware": "",
//                "os": "",
//                "itemCaption": "おおきな文字で情報満載、イラストが多くて読みやすい、つまづくポイントもやさしく解説。いちばん新しいプログラミング入門書。",
//                "salesDate": "2010年05月",
//                "itemPrice": 3002,
//                "listPrice": 0,
//                "discountRate": 0,
//                "discountPrice": 0,
//                "itemUrl": "http://books.rakuten.co.jp/rb/6416569/",
//                "affiliateUrl": "",
//                "smallImageUrl": "http://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/2340/9784774142340.jpg?_ex=64x64",
//                "mediumImageUrl": "http://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/2340/9784774142340.jpg?_ex=120x120",
//                "largeImageUrl": "http://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/2340/9784774142340.jpg?_ex=200x200",
//                "chirayomiUrl": "",
//                "availability": "1",
//                "postageFlag": 1,
//                "limitedFlag": 0,
//                "reviewCount": 0,
//                "reviewAverage": "0.0",
//                "booksGenreId": "001005017"
//            }
        }else{
            println(error?.localizedDescription)
        }
        
    }

}