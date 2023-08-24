// import UIKit
// import Flutter
// import FirebaseCore
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
//
//     SwiftFlutterForegroundTaskPlugin.setPluginRegistrantCallback(registerPlugins)
//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//     }
//
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
//
// func registerPlugins(registry: FlutterPluginRegistry) {
//   GeneratedPluginRegistrant.register(with: registry)
// }
//
//

import UIKit
import Flutter
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
override func application(
    _ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
 FirebaseApp.configure()
 Messaging.messaging().delegate = self
 GeneratedPluginRegistrant.register(with: self)
    SwiftFlutterForegroundTaskPlugin.setPluginRegistrantCallback(registerPlugins)
  if #available(iOS 10.0, *) {
    // For iOS 10 display notification (sent via APNS)
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
} else {
    let settings: UIUserNotificationSettings =
    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
    application.registerUserNotificationSettings(settings)
}
application.registerForRemoteNotifications()
return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   }

   func registerPlugins(registry: FlutterPluginRegistry) {
     GeneratedPluginRegistrant.register(with: registry)
   }