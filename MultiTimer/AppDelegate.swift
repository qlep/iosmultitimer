//
//  AppDelegate.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 8.9.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
import UserNotifications

private let categoryIdentifier = "DoneOrNone"

private enum ActionIdentifier: String {
    case done, again
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // register custom actions, use action category identifier when scheduling notification
    private func registerCustomActions() {
        let done = UNNotificationAction(identifier: ActionIdentifier.done.rawValue, title: "Done")
        let again = UNNotificationAction(identifier: ActionIdentifier.again.rawValue, title: "Again")
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [done, again], intentIdentifiers: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerCustomActions()
        application.applicationIconBadgeNumber = 0
        
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
}

// MARK: - UserNotificationCenterDelegate
extension TimerListTableViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // use .banner to present banner in foreground
        completionHandler([.list, .banner, .sound, .badge])
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // when user taps notification banner
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        
        let identity = response.notification.request.content.categoryIdentifier
        guard identity == categoryIdentifier, let action = ActionIdentifier(rawValue: response.actionIdentifier) else {return}
        
        let userInfo = response.notification.request.content.userInfo
        
        switch action {
        case .done:
            Notification.Name.doneButton.post(userInfo: userInfo)
        case .again:
            Notification.Name.againButton.post(userInfo: userInfo)
        }
    }
}

