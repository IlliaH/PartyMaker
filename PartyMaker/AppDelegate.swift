//
//  AppDelegate.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-10-07.
//  Copyright © 2019 711Development. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    // Getting current VC
    static var visibleViewController: UIViewController?

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        var currentVC : LoginController!
        
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        let photo = user.profile.imageURL(withDimension: 1)
        
        guard let token = idToken else {return}
        
        currentVC = AppDelegate.visibleViewController as? LoginController
        if let currentVC = currentVC {
            currentVC.presenter.googleLoginButtonClicked(tokenID: token)
        }
        
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize sign-in
        GIDSignIn.sharedInstance()?.clientID = "765272374924-aeh4csiofl5u932kb9vlc0rc6i0l81d1.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        // Customize tab bar button color
        // Override point for customization after application launch.
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }


}




extension AppDelegate {
    var visibleViewController: UIViewController? {
        return getVisibleViewController(nil)
    }

    private func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {

        let rootVC = rootViewController ?? UIApplication.shared.keyWindow?.rootViewController

        if rootVC!.isKind(of: UINavigationController.self) {
            let navigationController = rootVC as! UINavigationController
            return getVisibleViewController(navigationController.viewControllers.last!)
        }

        if rootVC!.isKind(of: UITabBarController.self) {
            let tabBarController = rootVC as! UITabBarController
            return getVisibleViewController(tabBarController.selectedViewController!)
        }

        if let presentedVC = rootVC?.presentedViewController {
            return getVisibleViewController(presentedVC)
        }

        return rootVC
    }
}

