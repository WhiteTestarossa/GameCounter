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
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!, NSAttributedString.Key.foregroundColor: Colors.shared.buttonColor], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.gray], for: .highlighted)
        
        UINavigationBar.appearance().barTintColor = Colors.shared.backgroundColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()

        let navigationController = UINavigationController(rootViewController: getRootViewController())
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func getRootViewController() -> UIViewController {
        guard let scoreHandler = ScoreHandling.load() else {
            return NewGameViewController(scoreHandler: ScoreHandling())
        }
        return GameViewController(scoreHandler: scoreHandler)
    }
    
    func clear(){
        UserDefaults.standard.removeObject(forKey: "gameData")
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController: UINavigationController {
        get {
            return window?.rootViewController as! UINavigationController
        }
        set {
            window?.rootViewController = newValue
        }
    }
}

