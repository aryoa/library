//
//  BookInfo.swift
//  library
//
//  Created by ryo on 2015/09/12.
//  Copyright (c) 2015年 ryo. All rights reserved.
//

import Foundation


class BookInfo : NSObject{
    var title:String         // 書籍タイトル
    var author:String        // 著者
    var image:String         // 画像イメージ
    var publisherName:String // 出版社
    var itemCaption:String   // 書籍内容
    var salesDate:String     // 発売日
    var itemURL:String       // 楽天へのリンク
    var isbn:String       // ISBN
    
    init(title:String, author:String, image:String, publisherName:String, itemCaption:String, salesDate:String, itemURL:String, isbn:String){
        self.title = title
        self.author = author
        self.image = image
        self.publisherName = publisherName
        self.itemCaption = itemCaption
        self.salesDate = salesDate
        self.itemURL = itemURL
        self.isbn = isbn
    }
}