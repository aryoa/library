//
//  listTableViewController.swift
//  booklog
//
//  Created by arao on 2015/07/22.
//  Copyright (c) 2015年 arao. All rights reserved.
//

//import Foundation

import UIKit


class ListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // ナビゲーションバーの右上にボタンを用意
    var addBtn: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var tmp:SampleView!
    
    // テーブルを用意
    var piyo: UITableView!
    
    // テーブルに表示するアイテム
    var books:[Book] = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "List"
        
        // addBtnを配置
        addBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "onClick")
        self.navigationItem.rightBarButtonItem = addBtn
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "onClickCancel")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        
        // 画面サイズを取得
        let width: CGFloat! = self.view.bounds.width
        let height: CGFloat! = self.view.bounds.height
        
        
        
        // テーブルを用意して、表示
        piyo = UITableView(frame: CGRectMake(0, 0, width, height))
        piyo.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCell")
        
        piyo.rowHeight = UITableViewAutomaticDimension;
        

        piyo.dataSource = self
        piyo.delegate = self
        self.view.addSubview(piyo)
        
        
        self.setupBooks()
        
        
        // HTTP通信のテスト
        let racten = RactenAPI(isbn: "978477414234")
        racten.getJSONWithISBN()
        
        
        // Evernote用のテスト
        // たぶん最初にauthenticateWithViewControllerをやる必要がある

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onClickCancel(){
        if tmp != nil {
            tmp.removeFromSuperview()
            tmp = nil
        }
        
//        let session = EvernoteSession.sharedSession()
//        println("session host: \(session.host)")
//        println("session key: \(session.consumerKey)")
//        println("session secret: \(session.consumerSecret)")
//        
//
//        
//        session.authenticateWithViewController(self, completionHandler: { error in
//            if (error != nil || !session.isAuthenticated ){
//                if (error != nil){
//                    println("Error authenticating with Evernote Cloud API \(error)")
//                }
//                if (!session.isAuthenticated){
//                    println("Session not authenticated")
//                }
//            } else {
//            }
//        })
//        let aaa = EvernoteUserStore()
//        let userStore = aaa.userStore //EDAMUserStoreClient
   
    }
    
    // Evernote用
    private func postTestNote() {
        var session = ENSession.sharedSession()

        let static_text = "testtesttest"
        var note = ENNote()
        note.title = "testaaaaa"
        note.content = ENNoteContent(string: static_text)
        
        session.listNotebooksWithCompletion( {(enNotebooks:[AnyObject]!,listNotebooksError:NSError!) -> Void in
            
            if listNotebooksError != nil {
                println(listNotebooksError?.localizedDescription)
                return
            }
            
            ENSession.sharedSession().uploadNote(note, notebook: enNotebooks[0] as? ENNotebook, completion: { (noteRef, error) -> Void in
                
                if error != nil {
                    println(error?.localizedDescription)
                    println("ERROR uploadNote")
                }else{
                    println("OK uploadNote")
                }
            })
            
        })

    }
    
    
    func onClick(){

        var session = ENSession.sharedSession()
        
        session.authenticateWithViewController(self, preferRegistration: false, completion: { error in
            if error == nil {
                
                
                session.listNotebooksWithCompletion( {(enNotebooks:[AnyObject]!,listNotebooksError:NSError!) -> Void in
                    
                    if listNotebooksError != nil {
                        println(listNotebooksError?.localizedDescription)
                        return
                    }
                    
                    println(enNotebooks)
                    enNotebooks[0]
//                    enNotebooks.map({println($0.ENNotebook)})

                })
            } else {
                println("Authentication error: \(error)")
                println(error?.localizedDescription)

            }
        })
        
        if (session.isAuthenticated){
            println("isAuthentucated Yes")
            postTestNote()
        }else{
            println("isAuthentucated NO")

        }
        
        

        

        return
        // 遷移するViewを定義する.
        let barcodeViewController: UIViewController = BarcodeViewController()
        
        // アニメーションを設定する.
        barcodeViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        // Viewの移動する.
        self.presentViewController(barcodeViewController, animated: true, completion: nil)
//        
        
//        //UIViewController.viewの座標取得
//        var x:CGFloat = self.view.bounds.origin.x
//        var y:CGFloat = self.view.bounds.origin.y
//        
//        //UIViewController.viewの幅と高さを取得
//        var width:CGFloat = self.view.bounds.width;
//        var height:CGFloat = self.view.bounds.height
//        
//        //上記より画面ぴったりサイズのフレームを生成する
//        //var frame:CGRect = CGRect(x: x, y: y, width: width, height: height)
//        var frame:CGRect = CGRect(x: 100, y: 100, width: 200, height: 200)
//        
//
//        //カスタマイズViewを生成
//        var myVeiw:SampleView = SampleView(frame: frame)
//        
//        tmp = myVeiw
//        //カスタマイズViewを追加
//        self.piyo.addSubview(myVeiw)
        
    }
    
    
    func setupBooks(){
        var book1 = Book(name: "Book1", imageUrl: NSURL(string: "http://xxxxxx"))
        var book2 = Book(name: "Book2", imageUrl: NSURL(string: "http://xxxxxx"))
        var book3 = Book(name: "Book3", imageUrl: NSURL(string: "http://xxxxxx"))
        
        books.append(book1)
        books.append(book2)
        books.append(book3)
        
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    // セクション高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 60 // 高さを自由に変えられるっぽい
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count;
        
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let identifier = "BookCell"
        let cell: BookCell = piyo.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as BookCell
        
        cell.setCell(books[indexPath.row])
        return cell
    }
    
}
