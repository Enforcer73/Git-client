//
//  AppDelegate.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    //MARK: - Authorization check
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.showTabBarVC()
            }
        }
        return true
    }

    //MARK: - Move to TabBar
    func showTabBarVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "toTabBar") as! TabBarViewController
        tabVC.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(tabVC, animated: false, completion: nil)
    }
}

