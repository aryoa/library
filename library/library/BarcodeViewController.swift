//
//  BarcodeViewController.swift
//  library
//
//  Created by ryo on 2015/09/12.
//  Copyright (c) 2015年 ryo. All rights reserved.
//

// ここのコードを使用
// http://swift-salaryman.com/avmetadataobject.php
import UIKit
import AVFoundation

class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session: AVCaptureSession = AVCaptureSession()
    var prevlayer: AVCaptureVideoPreviewLayer!
    var hview: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Barcode Scan"
        // Cancelボタン
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonClick")
        self.navigationItem.leftBarButtonItem = cancelButton

        
        // テスト用にAddボタンを追加
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonClick")
        self.navigationItem.rightBarButtonItem = addButton
        
        
        
        //準備（サイズ調整、ボーダーカラー、カメラオブジェクト取得、エラー処理）
        self.hview.autoresizingMask =   [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        self.hview.layer.borderColor = UIColor.greenColor().CGColor
        self.hview.layer.borderWidth = 3
        self.view.addSubview(self.hview)
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let error : NSError? = nil
        
        //インプット
        var input : AVCaptureDeviceInput?
        do{
            input = try AVCaptureDeviceInput(device: device)
        }catch {
            // Error handling...
            return
        }
        if input != nil {
            session.addInput(input)//カメラインプットセット
        }else {
            print(error)
        }
        
        //アウトプット
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)//プレビューアウトプットセット
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        prevlayer = AVCaptureVideoPreviewLayer(session: session)
        prevlayer.frame = self.view.bounds
        prevlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(prevlayer)
        
        session.startRunning()//開始！
        

        
    }
    
    //バーコードが見つかった時に呼ばれる
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        
        // http://qiita.com/hkato193/items/c36a940c2929a124e416
        
        var detectionString : String!
        
        //複数のバーコードの同時取得も可能
        for metadata in metadataObjects {
            // 一次元・二次元コード以外は無視する
            // ※人物顔の識別結果だった場合など
            if !metadata.isKindOfClass(AVMetadataMachineReadableCodeObject){
                continue
            }
            
            if metadata.type == AVMetadataObjectTypeEAN13Code {
                self.prevlayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                
                let prefix: String = (detectionString as NSString).substringToIndex(3)
                if prefix == "978" || prefix == "979" { // ISBNかどうかをチェックする
                    print(detectionString)
                    self.session.stopRunning()
                    self.addBookInfo(detectionString)
                    break
                }
            }
        }
    }
    
    // Cancelボタンが呼ばれた時の処理
    func cancelButtonClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // テスト用にAddボタンを追加
    func addButtonClick(){
        addBookInfo("9784890853946")
    }
    
    func addBookInfo(isbn: String){
        // Core Dataの内容を確認し、未登録の場合のみ登録
        let coreDataStore = CoreDataStore.sharedInstance
        if coreDataStore.isRegisterISBN(isbn) == false{
            // 取得に成功した場合は、前の画面に戻る
            if getBookInfoFromRakuten(isbn) {
                // 楽天からの情報取得に成功した場合は、前の画面に戻る
                self.navigationController?.popViewControllerAnimated(true)
            }
        }else{
            // 登録済みの場合も、前の画面に戻る
            print("登録済み")
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    // 楽天のAPIを使って、書籍情報を取得
    func getBookInfoFromRakuten(isbn: String) -> Bool{
        
        let ractenAPI = RactenAPI.sharedInstance
        let dataDic = ractenAPI.getJSONWithISBN(isbn)
        if dataDic != nil{
            
            let items: NSArray! = (dataDic["Items"] as? NSArray)
            if items == nil{
                // 楽天APIでなんらかのエラーが返ってきた場合はアラートを表示
                var message = dataDic["error_description"] as! String?
                if message == nil{
                    message = "An unexpected error"
                }
                let alertController = UIAlertController(title: "ERROR!", message: message, preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
                    self.session.startRunning()//開始！
                })
                alertController.addAction(defaultAction)
                
                presentViewController(alertController, animated: true, completion: nil)
                return false
                
            }else{
                if items.count == 0{
                    let message = "Not found"
                    let alertController = UIAlertController(title: "Warning!", message: message, preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
                        self.session.startRunning()//開始！
                    })
                    alertController.addAction(defaultAction)
                    
                    presentViewController(alertController, animated: true, completion:nil)
                    return false
                    
                }
                let tmp:NSDictionary! = items[0] as? NSDictionary
                
                let item = tmp["Item"] as? NSDictionary
                // Core Dataに書き込み
                let coreDataStore = CoreDataStore.sharedInstance
                coreDataStore.insertToCoreDataWithDictionary(item!)
            }
            
        }else{
            // ネットに繋がっていない場合などは、アラート表示
            let alertController = UIAlertController(title: "ERROR!", message: "Unable to connect to the server", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
                self.session.startRunning()//開始！
            })
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        
        return true
    }
}