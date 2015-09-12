//
//  BookInfoEntity.swift
//  library
//
//  Created by ryo on 2015/09/12.
//  Copyright (c) 2015年 ryo. All rights reserved.
//

import Foundation
import CoreData

class BookInfoEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var image: String
    @NSManaged var isbn: String
    @NSManaged var itemCaption: String
    @NSManaged var itemURL: String
    @NSManaged var publisherName: String
    @NSManaged var salesDate: String

}
