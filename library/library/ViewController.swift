//
//  ViewController.swift
//  library
//
//  Created by ryo on 2015/09/12.
//  Copyright (c) 2015年 ryo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var listTableView: UITableView!
    private var dataSource = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Library"
        // 追加ボタン
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonClick")
        self.navigationItem.rightBarButtonItem = addButton
        
        // テーブルビューを用意して表示
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        listTableView = UITableView(frame: CGRectMake(0, 0, width, height))
        listTableView.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCell")
        listTableView.dataSource = self
        listTableView.delegate = self
        self.view.addSubview(listTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        self.reload()
    }
    
    // cell選択時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // バーコード読み取り画面に移行
        let webViewController = WebViewController()
        // アニメーションを設定する
        webViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        
        let bookInfo = self.dataSource[indexPath.row] as? BookInfo
        webViewController.targetURL = bookInfo!.itemURL
        // Viewの移動
        self.navigationController?.pushViewController(webViewController, animated: true)
        
    }
    

    
    
    // Addボタンが呼ばれた時の処理
    func addButtonClick(){
        
        // バーコード読み取り画面に移行
        let barcodeViewController = BarcodeViewController()
        // アニメーションを設定する
        barcodeViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        // Viewの移動
        self.navigationController?.pushViewController(barcodeViewController, animated: true)
    }
    
    // セクション高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60 // 高さを自由に変えられるっぽい
    }
    
    // セルの行数を指定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    // セルの値を設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "BookCell"
        let cell: BookCell = listTableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookCell
        
        let bookInfo = self.dataSource[indexPath.row] as? BookInfo
        
        cell.bookTitle.text = bookInfo!.title
        cell.bookAuthor.text = bookInfo!.author
        
        // imageは非同期で取得し、表示する
        if (bookInfo!.image != "No image"){
            let url = NSURL(string:bookInfo!.image)
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data)
                cell.bookImage.image = image
            }
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            let bookInfo = self.dataSource[indexPath.row] as? BookInfo
            
            // Core dataから削除
            let coreDataStore = CoreDataStore.sharedInstance
            coreDataStore.deleteWithISBN(bookInfo!.isbn)
            
            // リロード
            self.reload()

        }
    }
    

    
    // CoreDataの情報をもとにdataSourceとViewを更新する
    func reload(){
        let coreDataStore = CoreDataStore.sharedInstance
        let itemArray = coreDataStore.getBookInfoFromCoreData() as NSArray
        self.dataSource = itemArray
        self.listTableView.reloadData()
    }
    
}

