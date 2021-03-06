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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        //launch directly into HomeVC if a user is cached
        if Auth.auth().currentUser != nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "homeNavigationController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            loggedInBool = true
            
            return true
            
        }
        
        let key = "FirstRun"
        if UserDefaults.standard.object(forKey: key) == nil {
            let keychain = Keychain(service: "com.itsFree")
            do {
                try keychain.removeAll()
            } catch {
                print("Error clearing Keychain")
            }
            UserDefaults.standard.set(true, forKey: key)
            UserDefaults.standard.set(false, forKey: "rememberMe")
            UserDefaults.standard.synchronize()
        }
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
    
    
    //This is called when the app is opened through the URL Scheme
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        //make sure the url prefix/scheme is right.
        if(url.scheme == "iospassitonapp"){
            print("Scheme is: \(url.scheme!)")
            print("Query is: \(url.query!)")
            
            //if no user logged in, loggedInBool will be nil. So present alert telling them to log in
            if Auth.auth().currentUser == nil {
          
                
//                if let mainNavVC = self.window?.rootViewController as? UINavigationController,
//                    let homeVC = mainNavVC.viewControllers[0] as? HomeViewController {
//
//                    homeVC.loginAndRate(url: url)
//                }
        
            }
                
            //else if we were logged in, loggedInBool would be true. So just go to rating the user.
            else {
                openedThroughSchema(url: url)
                
            }
            
            //if it was a available item
            //if link is clicked, send an email to seller saying thanks, and take me to the post to delete the item,
            
            return true
        }
            
        else {
            return false
        }
    }
    
    
    //connector method to parse the url from the scheme link
    @objc func openedThroughSchema(url: URL) {
        
        let ratingSystem = RatingSystem()
        ratingSystem.updateDataBeforeRating(url: url)
        
        //should we deinitialize the instance of rating system?
   
    }
}

