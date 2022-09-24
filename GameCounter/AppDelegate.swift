//
//  AppDelegate.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 23.09.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            // Fallback on earlier versions
        }
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!, NSAttributedString.Key.foregroundColor: Colors.shared.buttonColor], for: .normal)
        
        
        self.window?.rootViewController = rootViewController()
    
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func rootViewController() -> UIViewController {
        let newGameVC = AddPlayerViewController()
        let navigationController = UINavigationController(rootViewController: newGameVC)
        
        return navigationController
    }

}

