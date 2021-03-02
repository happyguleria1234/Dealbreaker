//
//  AppDelegate.swift
//  DealBreakers
//
//  Created by apple on 2/28/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import FacebookLogin
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var chatListArr = [ChatListModel]()
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
           if let error = error {
               print(error.localizedDescription)
               return
           }
       }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
          let handled:Bool = (ApplicationDelegate.shared.application(app, open: url, options:options))
          print("handle",handled)

          return handled
      }


    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled =  ApplicationDelegate.shared.application(application,
                                                                             open: url,
                                                                             sourceApplication: sourceApplication,
                                                                             annotation: annotation)

        return handled
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        sleep(5)
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.configureNotification()
        self.getLoggedUser()
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func getLoggedUser(){
        let credentials = UserDefaults.standard.bool(forKey: "tokenFString")
        if credentials == true{
            
            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            let storyBoard = UIStoryboard.init(name: "Profile", bundle: nil)
            let rootVc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            navigationController?.pushViewController(rootVc, animated: false)
        }else{
            
            if UserDefaults.standard.bool(forKey: "FirstTimeOpen") == false{
                UserDefaults.standard.set(true, forKey: "FirstTimeOpen")
                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
                let storyBoard = UIStoryboard.init(name: "Authentication", bundle: nil)
                let rootVc = storyBoard.instantiateViewController(withIdentifier: "IntroScreensVC") as! IntroScreensVC
                navigationController?.pushViewController(rootVc, animated: false)
            }
        }
    }
    
    
    
    func logout(){
//        FacebookSignInManager.logoutFromFacebook()
        let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
        let storyBoard = UIStoryboard.init(name: "Authentication", bundle: nil)
        let rootVc = storyBoard.instantiateViewController(withIdentifier: "SignUpWithVC") as! SignUpWithVC
        navigationController?.pushViewController(rootVc, animated: false)
    }
}

func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
extension AppDelegate: UNUserNotificationCenterDelegate{
    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        }else{
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //touch action
        // tell the app that we have finished processing the user’s action / response
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    if let detail = dataObj["detail"] as? [String:Any]{
                        let notificationType = detail["notification_type"] as? String
                        let state = UIApplication.shared.applicationState
                        if state != .active{
                            if notificationType == "chat"{
                                let storyBoard = UIStoryboard.init(name: "Profile", bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                                chatListArr = [ChatListModel(about: detail["about"] as? String ?? "", account_verfication: detail["account_verfication"] as? String ?? "", address: detail["address"] as? String ?? "", age: detail["age"] as? String ?? "", badge_count: "", created_at_message: "", creation_time: detail["creation_time"] as? String ?? "", distance_in_feet: "", distance_in_kms: "", distance_in_miles: "", dob: detail["dob"] as? String ?? "", email: detail["email"] as? String ?? "", enabled: detail["enabled"] as? String ?? "", fb_id: detail["fb_id"] as? String ?? "", gender: detail["gender"] as? String ?? "", image: detail["image"] as? [String] ?? [""], isTextImage: detail["isTextImage"] as? String ?? "", last_message: detail["last_message"] as? String ?? "", latitude: detail["latitude"] as? String ?? "", logged_in_status: detail["logged_in_status"] as? String ?? "", longitude: detail["longitude"] as? String ?? "", name: detail["name"] as? String ?? "", occupation: detail["occupation"] as? String ?? "", password: "", phone: detail["phone"] as? String ?? "", receiver_id: detail["receiver_id"] as? String ?? "", room_id: detail["room_id"] as? String ?? "", school: detail["school"] as? String ?? "", sender_id: detail["sender_id"] as? String ?? "", user_id: detail["user_id"] as? String ?? "")]
                                rootVc.chatListArr = chatListArr
                                rootVc.isFrom = "push"
                                let nav = UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true
                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first{
                                        guard let windowScene = (scene as? UIWindowScene) else { return }
                                        print(">>> windowScene: \(windowScene)")
                                        let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                            }else{
                                let storyBoard = UIStoryboard.init(name: "Profile", bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                                chatListArr = [ChatListModel(about:"", account_verfication: "", address: "", age: "", badge_count: "", created_at_message: "", creation_time: "", distance_in_feet: "", distance_in_kms: "", distance_in_miles: "", dob: "", email: "", enabled: "", fb_id: "", gender:"", image: detail["image"] as? [String] ?? [""], isTextImage:"", last_message: "", latitude:"", logged_in_status: "", longitude: "", name: detail["name"] as? String ?? "", occupation: "", password: "", phone: "", receiver_id: detail["receiver_id"] as? String ?? "", room_id: detail["room_id"] as? String ?? "", school: "", sender_id: detail["sender_id"] as? String ?? "", user_id: detail["user_id"] as? String ?? "")]
                                rootVc.chatListArr = chatListArr
                                rootVc.isFrom = "push"
                                let nav = UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true
                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first{
                                        guard let windowScene = (scene as? UIWindowScene) else { return }
                                        print(">>> windowScene: \(windowScene)")
                                        let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         let userInfo = notification.request.content.userInfo
         print("message received")
         completionHandler([])
     }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
         print("device token", deviceTokenString)
         UserDefaults.standard.set(deviceTokenString as String, forKey: "device_token")
         Auth.auth().setAPNSToken(deviceToken, type: .unknown)
         InstanceID.instanceID().instanceID { (result, error) in
             if let error = error {
                 print("Error fetching remote instange ID: \(error)")
                 //UserDefaults.standard.set("d9WS_Q4LeAo:APA91bH_Q8mPhHT6h3ipL3hoJBiU5FXhEBoUMV1JW-vAla_HuodrTZRcGO9ALvi7fzabVjbbzi_x56HOXdPDhVvYwcPnA0lAA_owWtfJmZVTUGSaa6Gjj9SCTFvyf1dPj43INTU5GbpF", forKey:"DeviceToken")
             } else if let result = result {
                 print("Remote instance ID token: \(result.token)")
                 //  UserDefaults.standard.set(result.token, forKey:"DeviceToken")
             }
         }
     }

    
     
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         
         print("i am not available in simulator :( \(error)")
     }
}

