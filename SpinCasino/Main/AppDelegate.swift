//
//  AppDelegate.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 16.08.2021.
//

import UIKit
import Firebase
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let checker = Checker.shared
    let appsFlyer = AppsFlyerLib.shared()
    var didCheck = false
    var initVC: InitViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IAPManager.shared.fetchProducts()
        setUpFirebase()
        setUpAppsFlyer()
//        check()
        UserDefaultsManager.reg()
        UIApplication.shared.isIdleTimerDisabled = true
        application.registerForRemoteNotifications()
        setInitVC()
        
        return true
    }
    
    func setInitVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(withIdentifier: "InitViewController") as! InitViewController
        self.initVC = initialVC
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
        
        if let _ = Checker.savedHomeTrack {
            check()
        }
    }
    
    func check() {
//        appsFlyer.logEvent("dep", withValues: [:])
//        appsFlyer.logEvent("registration", withValues: [:])
//        appsFlyer.logEvent("test", withValues: [:])
        
        didCheck = true
        DispatchQueue.main.async {
            self.initVC?.checkWithChecker()
        }
    }
    
    func setUpAppsFlyer() {
        appsFlyer.appsFlyerDevKey = Consts.appsFlyerDevKey
        appsFlyer.appleAppID = Consts.appID
        appsFlyer.delegate = self // TODO
        /* Set isDebug to true to see AppsFlyer debug logs */
        appsFlyer.isDebug = false
        appsFlyer.shouldCollectDeviceName = true
    }
    
    func setUpFirebase() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        appsFlyer.handlePushNotification(userInfo)
        SegmentManager.handlePushNotification(userInfo)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        appsFlyer.handleOpen(url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        appsFlyer.continue(userActivity, restorationHandler: nil)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
        appsFlyer.start()
    }

}

extension AppDelegate: AppsFlyerLibDelegate {
    
    // AppsFlyerTrackerDelegate implementation
    
    //Handle Conversion Data (Deferred Deep Link)
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        print("\(data)")
        
        if let status = data["af_status"] as? String, status == "Non-organic" {
            print("This is a non organic install.")
        } else {
            print("This is an organic install.")
        }
        
        if let campaign = data["campaign"] as? String {
            print("Campaign name: \(campaign)")
            UserDefaultsManager.compaign = campaign
        }
        
        if !didCheck {
            check()
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print("\(error)")
        if !didCheck {
            check()
        }
    }
    
    //Handle Direct Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        //Handle Deep Link Data
        print("\(attributionData)")
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print("\(error)")
    }
    
}

