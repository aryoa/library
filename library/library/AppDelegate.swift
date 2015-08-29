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
        
        
        // Evernote用に追加
        let EVERNOTE_HOST = ENSessionHostSandbox
        let CONSUMER_KEY = "ryo"
        let CONSUMER_SECRET = "174425a709d7f629"
        
        ENSession.setSharedSessionConsumerKey(CONSUMER_KEY, consumerSecret: CONSUMER_SECRET,
            optionalHost: EVERNOTE_HOST)
        
        
//        // Evernote用に追加
//        let EVERNOTE_HOST = BootstrapServerBaseURLStringSandbox
//        let CONSUMER_KEY = "ryo"
//        let CONSUMER_SECRET = "174425a709d7f629"
//        EvernoteSession.setSharedSessionHost(EVERNOTE_HOST, consumerKey:CONSUMER_KEY, consumerSecret:CONSUMER_SECRET);
        

        
        
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
        
//        // Evernote用に追加
//        EvernoteSession.sharedSession().handleDidBecomeActive()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
//    // Evernote用に追加
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        var canHandle = false
//        if "en-" + EvernoteSession.sharedSession().consumerKey == url.scheme{
//            canHandle = EvernoteSession.sharedSession().canHandleOpenURL(url)
//        }
//        return canHandle
//    }

}

