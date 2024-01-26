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
import flutter_background_service_ios // add this
import CoreLocation


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate, CLLocationManagerDelegate {
    
    
    private var bearerToken: String = ""

   
    
    
    
override func application(
    _ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    
    
    
    
    
           let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
           let channel = FlutterMethodChannel(name: "FlutterFramework/swift_native", binaryMessenger: controller.binaryMessenger)
           
           channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
               if call.method == "getSum" {
                   let args = call.arguments as? [String: Any] ?? [:] // Extract arguments from Flutter
                   
                   if let value1 = args["value1"] as? Int,
                                    let value2 = args["value2"] as? Int,
                                    let token = args["token"] as? String
                                 {
                                     // Store the bearer token
                                     self?.bearerToken = token

                                     // Use the arguments as needed in your Swift code
                                     let sum = self?.getSum(value1: value1, value2: value2) ?? 0
                                     result(sum)
                   } else {
                       result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments from Flutter", details: nil))
                   }
               } else {
                   result(FlutterMethodNotImplemented)
               }
           }

    
    
    
    
    
    

 SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"
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
    
    
    
    private func getSum(value1: Int, value2: Int) -> Int {
        if(value1==0){
            stopLocationService();
        }else{
            getUserLocation()

        }
           return value1 + value2 + 5
       }
private var locationManager:CLLocationManager?





func getUserLocation() {
            locationManager = CLLocationManager()
            locationManager?.requestAlwaysAuthorization()
            locationManager?.startUpdatingLocation()
            locationManager?.delegate = self
            locationManager?.allowsBackgroundLocationUpdates = true
        }


       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             if let location = locations.last {
                    print("Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")

                 
                 
                 // Send location data to API with bearer token
               
                 sendLocationToAPIWithToken(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        
             }
         }
    
    
    
    
    
    
    
    
    
    func sendLocationToAPIWithToken(latitude: Double, longitude: Double) {
          let apiUrl = "http://192.168.0.50:8087/v1/api/tema/updateGeoLocation" // Replace with your API endpoint URL

          guard let url = URL(string: apiUrl) else {
              print("Invalid API URL")
              return
          }

        var request = URLRequest(url: url)
             request.httpMethod = "POST"
             request.setValue("application/json", forHTTPHeaderField: "Content-Type")
             request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization") // Include the bearer token in the header

             let parameters: [String: Any] = [
                 "latitude": latitude,
                 "longitude": longitude
             ]
       
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("Failed to serialize JSON data: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending location data to API: \(error)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }
        }

        task.resume()
    }
    
    
    func stopLocationService() {
          if let locationManager = self.locationManager {
              locationManager.stopUpdatingLocation()
              locationManager.delegate = nil
              self.locationManager = nil
          }
      }
    
   }













   func registerPlugins(registry: FlutterPluginRegistry) {
     GeneratedPluginRegistrant.register(with: registry)
   }







