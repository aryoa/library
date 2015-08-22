//
//  Books.swift
//  booklog
//
//  Created by arao on 2015/07/22.
//  Copyright (c) 2015年 arao. All rights reserved.
//

import Foundation

class Book : NSObject{
    var name: NSString
    
    init(name: String, imageUrl: NSURL?){
        self.name = name
    }
}
