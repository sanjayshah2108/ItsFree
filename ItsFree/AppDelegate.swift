//
//  AppDelegate.swift
//  ItsFree
//
//  Created by Sanjay Shah on 2017-11-16.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import Firebase
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    @objc func openedThroughSchema(url: URL) {
        
        let mainVC = self.window?.rootViewController as! LoginViewController
        var currentVC: UIViewController
        
        if(mainVC.presentedViewController != nil){
            let presentedVC = mainVC.presentedViewController as! UINavigationController
             currentVC = presentedVC.viewControllers[0] as! HomeViewController
            
        }
        else {
            currentVC = mainVC
        }
        
        let fullQuery = String("\(url.query!)")
        
        let itemStartIndex = fullQuery.index(fullQuery.startIndex, offsetBy: 7)
        let itemEndIndex = fullQuery.index(fullQuery.endIndex, offsetBy: -36)
        let itemRange = itemStartIndex..<itemEndIndex
        
        let substringitemID = fullQuery[itemRange]
        print(substringitemID)
        let itemID: String! = String(substringitemID)
        var item: Item
        
        if(AppData.sharedInstance.onlineRequestedItems.filter{ $0.UID == itemID}.first != nil){
            item = AppData.sharedInstance.onlineRequestedItems.filter{ $0.UID == itemID}.first!
            
            //ask user to delete his request
            
        }
        else {
            item = AppData.sharedInstance.onlineOfferedItems.filter{ $0.UID == itemID}.first!
        }
        
        
        
        print("Name: \(item.name)")
        
        let userStartIndex = fullQuery.index(fullQuery.startIndex, offsetBy: 35)
        let userEndIndex = fullQuery.index(fullQuery.endIndex, offsetBy: 0)
        let userRange = userStartIndex..<userEndIndex
        
        let substringUserID = fullQuery[userRange]
        print(substringUserID)
        let responderID: String! = String(substringUserID)
        
        if ((AppData.sharedInstance.onlineUsers.filter{ $0.UID == responderID}.first) != nil){
            let responder = AppData.sharedInstance.onlineUsers.filter{ $0.UID == responderID}.first
            
            
            print("Name: \(responder!.name)")
            
            var alert: UIAlertController!
            
            //if its an offered item, currentUser cannot vote if = respsonder
            if(AppData.sharedInstance.onlineOfferedItems.filter{ $0.UID == itemID}.first != nil){
                if(responderID != item.posterUID){
                    alert = UIAlertController(title: "You cannot vote yourself", message: "Upvote or downvote \(responder!.name)", preferredStyle: UIAlertControllerStyle.alert)
                    let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(okayAction)
                    
                }
                    
                    
                else {
                    
                    alert = UIAlertController(title: "Do you like the \(item.name)?", message: "Upvote or downvote \(responder!.name)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let upvoteAction = UIAlertAction(title: "Upvote", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in responder?.rating = (responder?.rating)!+1
                        AppData.sharedInstance.usersNode.child("\(responderID!)/rating").setValue(responder?.rating)
                    })
                    let downvoteAction = UIAlertAction(title: "Downvote", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in responder?.rating = (responder?.rating)!-1
                        AppData.sharedInstance.usersNode.child("\(responderID!)/rating").setValue(responder?.rating)
                    })
                    
                    alert.addAction(upvoteAction)
                    alert.addAction(downvoteAction)
                }
            }
                //if its a requested item, can only vote if posterID is currentID
            else {
                if(AppData.sharedInstance.currentUser?.UID == item.posterUID){
                    alert = UIAlertController(title: "Do you like the \(item.name)?", message: "Upvote or downvote \(responder!.name)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let upvoteAction = UIAlertAction(title: "Upvote", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in responder?.rating = (responder?.rating)!+1
                        AppData.sharedInstance.usersNode.child("\(responderID!)/rating").setValue(responder?.rating)
                    })
                    let downvoteAction = UIAlertAction(title: "Downvote", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in responder?.rating = (responder?.rating)!-1
                        AppData.sharedInstance.usersNode.child("\(responderID!)/rating").setValue(responder?.rating)
                    })
                    
                    alert.addAction(upvoteAction)
                    alert.addAction(downvoteAction)
                }
                else{
                    alert = UIAlertController(title: "You cannot vote yourself", message: "Upvote or downvote \(responder!.name)", preferredStyle: UIAlertControllerStyle.alert)
                    let okayAction = UIAlertAction(title: "Okay Lol", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(okayAction)
                }
            }
            
            
            
            currentVC.present(alert, animated: true, completion: nil)
        }
        else {
            let userDoesntExistAlert =  UIAlertController(title: "Oops", message: "User no longer exists", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil)
            
            userDoesntExistAlert.addAction(okayAction)
            
            currentVC.present(userDoesntExistAlert, animated: true, completion: nil)
            
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //FirebaseOptions.defaultOptions()?.deepLinkURLScheme = self.customURLScheme
        FirebaseApp.configure()
        
        
        
        let key = "FirstRun"
        if UserDefaults.standard.object(forKey: key) == nil {
            let keychain = Keychain(service: "com.itsFree")
            do {
                try keychain.removeAll()
            } catch {
                print("Error clearing Keychain")
            }
            UserDefaults.standard.set(true, forKey: key)
            UserDefaults.standard.set(false, forKey: rememberMeKey)
            UserDefaults.standard.synchronize()
        }
        
        //let url = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL
        
        //        let url = "iOSAnotherLifeApp://?itemID=-L-DUH71CeTf-7JWUHMw&userID=k5GdBLgYbbPQGAjmzGk6nIjO70F2" as? URL
//        if(url != nil){
//            //print(url)
//            //return self.application(application, open: url!)
//            openedThroughSchema(url: url!)
//        }
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        //FirebaseApp.configure()
        
        if(loggedInBool == nil){
            
            
            let mainVC = self.window?.rootViewController as! LoginViewController
            
            
            let loggedOutAlert = UIAlertController(title: "Oops", message: "You need to log in first", preferredStyle: UIAlertControllerStyle.alert)
            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {_ in mainVC.loginAndRate(url: url)})
            loggedOutAlert.addAction(okayAction)
            
            mainVC.present(loggedOutAlert, animated: true, completion: nil)
            
            
        }
        else if (loggedInBool){
            openedThroughSchema(url: url)
            
        }
        
        
        if(url.scheme == "iosanotherlifeapp"){
            print("Scheme is: \(url.scheme!)")
            print("Query is: \(url.query!)")
            
            
            
            
            //if it was a available item
            //if link is clicked, send an email to seller saying thanks, and take me to the post to delete the item,
            
            
            
            return true
        }
        else {
            return false
            
        }
        
    }
    
}

