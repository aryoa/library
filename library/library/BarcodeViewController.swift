//
//  BarcodeViewController.swift
//  library
//
//  Created by HIROKI YAMAMOTO on 2015/08/22.
//  Copyright (c) 2015年 arao. All rights reserved.
//

//import Foundation

// ここのコードを使用
// http://swift-salaryman.com/avmetadataobject.php
import UIKit
import AVFoundation

class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session: AVCaptureSession = AVCaptureSession()
    var prevlayer: AVCaptureVideoPreviewLayer!
    var hview: UIView = UIView()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    func setup() {
        self.title = "Barcode"
////        // Viewの背景色をGreenに設定する.
////        self.view.backgroundColor = UIColor.greenColor()
//        
//        // tabBarItemのアイコンをFeaturedに、タグを2と定義する.
//        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 2)
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //準備（サイズ調整、ボーダーカラー、カメラオブジェクト取得、エラー処理）
        self.hview.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleRightMargin
        self.hview.layer.borderColor = UIColor.greenColor().CGColor
        self.hview.layer.borderWidth = 3
        self.view.addSubview(self.hview)
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError? = nil
        
        //インプット
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        if input != nil {
            session.addInput(input)//カメラインプットセット
        }else {
            println(error)
        }
        
        //アウトプット
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)//プレビューアウトプットセット
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        prevlayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as AVCaptureVideoPreviewLayer
        prevlayer.frame = self.view.bounds
        prevlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(prevlayer)
        
        session.startRunning()//開始！
        
    }
    
    //バーコードが見つかった時に呼ばれる
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        
        // http://qiita.com/hkato193/items/c36a940c2929a124e416
        
        
        var highlightViewRect = CGRectZero
        var barCodeObject : AVMetadataObject!
        var detectionString : String!
        
        //複数のバーコードの同時取得も可能
        for metadata in metadataObjects {
            // 一次元・二次元コード以外は無視する
            // ※人物顔の識別結果だった場合など
            if !metadata.isKindOfClass(AVMetadataMachineReadableCodeObject){
                continue
            }
            
            if metadata.type == AVMetadataObjectTypeEAN13Code {
                barCodeObject = self.prevlayer.transformedMetadataObjectForMetadataObject(metadata as AVMetadataMachineReadableCodeObject)
                detectionString = (metadata as AVMetadataMachineReadableCodeObject).stringValue
                
                var prefix: String = (detectionString as NSString).substringToIndex(3)
                if prefix == "978" || prefix == "979" { // ISBNかどうかをチェックする
                    println(detectionString)
                    self.session.stopRunning()
                    break
                }
            }
        }
    }
}