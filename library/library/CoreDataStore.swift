//
//  CoreDataStore.swift
//  library
//
//  Created by ryo on 2015/09/12.
//  Copyright (c) 2015年 ryo. All rights reserved.
//

// Core Dataにアクセスするためのシングルトン
import Foundation
import UIKit
import CoreData


class CoreDataStore {
    
    private let entityName = "BookInfoEntity"
    var readDataList = [NSManagedObject]()
    
    // singleton in Swift 1.2
    static let sharedInstance = CoreDataStore()
    

    // データの挿入
    func insertToCoreDataWithDictionary(bookInfo: NSDictionary){
        // AppDelegateクラスのインスタンスを取得
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        // ゲッターはプロジェクト作成時に自動生成されている
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            let entity = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext)
            var newData = BookInfoEntity(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            
            var title = bookInfo["title"] as? String
            if title == nil || title == ""{
                title = "No title"
            }
            
            var author = bookInfo["author"] as? String
            if author == nil || author == ""{
                author = "No author"
            }
            
            var image = bookInfo["largeImageUrl"] as? String
            if image == nil || image == ""{
                image = bookInfo["mediumImageUrl"] as? String
                if image == nil || image == ""{
                    image = bookInfo["smallImageUrl"] as? String
                    if image == nil || image == ""{
                        image = "No image"
                    }
                }
            }

            var publisherName = bookInfo["publisherName"] as? String
            if publisherName == nil || publisherName == ""{
                publisherName = "No publisherName"
            }
            
            var itemCaption = bookInfo["itemCaption"] as? String
            if itemCaption == nil || itemCaption == ""{
                itemCaption = "No itemCaption"
            }
            
            var salesDate = bookInfo["salesDate"] as? String
            if salesDate == nil || salesDate == ""{
                salesDate = "No salesDate"
            }
            
            var itemURL = bookInfo["itemUrl"] as? String
            if itemURL == nil || itemURL == ""{
                itemURL = "No item's url"
            }
            
            var isbn = bookInfo["isbn"] as? String
            if isbn == nil || isbn == ""{
                isbn = "No isbn"
            }

            newData.title = title!
            newData.author = author!
            newData.image = image!
            newData.publisherName = publisherName!
            newData.itemCaption = itemCaption!
            newData.salesDate = salesDate!
            newData.itemURL = itemURL!
            newData.isbn = isbn!
        }
    }

    
    
    // データの挿入
    func insertToCoreData(bookInfo: BookInfo){
        // AppDelegateクラスのインスタンスを取得
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        // ゲッターはプロジェクト作成時に自動生成されている
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            let entity = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext)
            var newData = BookInfoEntity(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            
            newData.title = bookInfo.title
            newData.author = bookInfo.author
            newData.image = bookInfo.image
            newData.publisherName = bookInfo.publisherName
            newData.itemCaption = bookInfo.itemCaption
            newData.salesDate = bookInfo.salesDate
            newData.itemURL = bookInfo.itemURL
            newData.isbn = bookInfo.isbn
        }
    }
    
    // データの読み取り
    func getBookInfoFromCoreData() -> NSArray!{
        var bookArray:[BookInfo] = []
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        let request: NSFetchRequest = NSFetchRequest(entityName: self.entityName)
        request.returnsObjectsAsFaults = false
        var results: NSArray! = managedObjectContext.executeFetchRequest(request, error: nil)
        
        for data in results{
            let book = BookInfo(title: data.title, author: data.author, image:data.image, publisherName: data.publisherName, itemCaption: data.itemCaption, salesDate: data.salesDate, itemURL: data.itemURL, isbn:data.isbn)
            bookArray.append(book)
        }
        
        return bookArray
    }
    
    // データの削除(未確認)
    func deleteWithISBN(isbn: String){
        // AppDelegateクラスのインスタンスを取得
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        // ゲッターはプロジェクト作成時に自動生成されている
        if let managedObjectContext = appDelegate.managedObjectContext {
            // EntityDescriptionのインスタンスを生成
            let entityDiscription = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext);
            // NSFetchRequest SQLのSelect文のようなイメージ
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            // NSPredicate SQLのWhere句のようなイメージ
            let predicate = NSPredicate(format: "%K = %@", "isbn", isbn)
            fetchRequest.predicate = predicate
            
            var error: NSError? = nil;
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let entity = managedObject as! BookInfoEntity;
                    //
                    // レコード削除！
                    //
                    managedObjectContext.deleteObject(entity);
                }
            }
            // AppDelegateクラスに自動生成された saveContext で保存完了
            appDelegate.saveContext()
        }
    }
    
    
    // データの検索
    func isRegisterISBN(isbn: String) -> Bool{
        // ここを参考にした
        // http://qiita.com/watanave/items/4da9f4bc97247f780af8
        // AppDelegateクラスのインスタンスを取得
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        // ゲッターはプロジェクト作成時に自動生成されている
        if let managedObjectContext = appDelegate.managedObjectContext {
            // EntityDescriptionのインスタンスを生成
            let entityDiscription = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext);
            // NSFetchRequest SQLのSelect文のようなイメージ
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            // NSPredicate SQLのWhere句のようなイメージ
            // someDataBプロパティが100のレコードを指定している
            let predicate = NSPredicate(format: "%K = %@", "isbn", isbn)
            fetchRequest.predicate = predicate
            
            var error: NSError? = nil;
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                if results.count > 0{
                    return true
                }
            }
        }
        return false
    }
    
    
}

