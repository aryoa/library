//
//  AppDelegate.swift
//  library
//
//  Created by HIROKI YAMAMOTO on 2015/08/22.
//  Copyright (c) 2015年 arao. All rights reserved.
//

// Optionalについては、ここが分かりやすいかも
// http://qiita.com/cotrpepe/items/518c4476ca957a42f5f1
// T? は Optional<T> のシンタックスシュガー。
// T! は ImplicitlyUnwrappedOptional<T> のシンタックスシュガー。
// Optional 型 - nil の代入を許す
// 非 optional 型 - nil の代入を許さない

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    
    private var tabBarController: UITabBarController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        // http://mimaunes.hatenablog.com/entry/20141227/1419659526 ここ参考
        // ViewControllerのインスタンス生成.
        let listTableViewController = ListTableViewController()
        let barcodeViewController = BarcodeViewController()
        
        // UINavigtaionController生成.
        let navi1 = UINavigationController(rootViewController: listTableViewController)
        let navi2 = UINavigationController(rootViewController: barcodeViewController)
        
        // 配列にUINavigationControllerを格納.
        var controllers = [navi1, navi2]
        
        // UITabBarController生成.
        let tabViewController = UITabBarController()
        
        // TabBarControllerのviewControllerにNavigationControllerをセット.
        tabViewController.viewControllers = controllers
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // rootViewControllerにTabBarControllerをセット.
        window?.rootViewController = tabViewController
        
        window?.makeKeyAndVisible()
        
        
////        let first: ListTableViewController = ListTableViewController()
////        navigationController = UINavigationController(rootViewController: first)
////        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
////        self.window?.rootViewController = navigationController
////        self.window?.makeKeyAndVisible()
//        
//        // タブバーの追加 こちらを参考に
//        // https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/uikit/uitabcontrollerdetabuno-biao-shi
//        
//        // タブバーはこちらも参考に
//        // http://www.tejitak.com/blog/?p=1027
//
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        
//        // Tabに設定するViewControllerのインスタンスを生成.
//        let listTableViewTab: UIViewController = ListTableViewController()
//        let barcodeViewTab: UIViewController = BarcodeViewController()
//        
//        // タブを要素に持つArrayの.を作成する.
//        let tabs = NSArray(objects: listTableViewTab, barcodeViewTab)
//        
//        listTableViewTab.tabBarItem = UITabBarItem(title: "リスト", image: nil, selectedImage: nil)
//        barcodeViewTab.tabBarItem = UITabBarItem(title: "バーコード", image: nil, selectedImage: nil)
//        
//        // UITabControllerの作成する.
//        tabBarController = UITabBarController()
//        
//        
//        // ViewControllerを設定する.
//        tabBarController?.setViewControllers(tabs as [AnyObject], animated: false)
//        
//        // RootViewControllerに設定する.
//        self.window!.rootViewController = tabBarController
//        
//        self.window!.makeKeyAndVisible()
        

        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

