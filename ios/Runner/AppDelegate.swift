
import UIKit
import Flutter
import Firebase
import flutter_background_service_ios // add this
import CoreLocation


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate, CLLocationManagerDelegate {



    private var bearerToken: String = ""
    private var myRefreshToken: String = ""
     private var myTime: Int = 20
 private var locationManager: CLLocationManager?
    private var timer: Timer?


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
                                    let token = args["token"] as? String,
                                     let refreshToken = args["refreshToken"] as? String,
                                     let  t = args["time"] as? Int
                                 {
                                     // Store the bearer token
                                     self?.bearerToken = token
                                     self?.myRefreshToken = refreshToken
                                     self?.myTime = t
print("time paramms:",t)
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








 FirebaseApp.configure()
 Messaging.messaging().delegate = self
 GeneratedPluginRegistrant.register(with: self)
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
    startTimer()
return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    func startTimer() {
        print("my time paramms:",self.myTime)
     timer = Timer.scheduledTimer(timeInterval: TimeInterval( self.myTime) ,target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        // Fire the timer immediately upon starting
        timer?.fire()
    }

    @objc func timerFired() {
        getRefreshToken()
        sendLocationToAPI()
    }


    func getRefreshToken() {
            let apiUrl = "https://next3.claims-express.net/v1/api/auth/refresh-token-app"

            guard let url = URL(string: apiUrl) else {
                print("Invalid API URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let parameters: [String: Any] = [
                "refreshToken": myRefreshToken
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                print("Failed to serialize JSON data: \(error)")
                return
            }

            URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
                guard let data = data, error == nil else {
                    print("Error retrieving data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                do {

                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                    self?.myRefreshToken = tokenResponse.refreshToken
              
                    self?.bearerToken = tokenResponse.token


                } catch {
                    print("Error decoding token response: \(error)")
                }
            }.resume()
        }





    private func getSum(value1: Int, value2: Int) -> Int {
        if(value1==0){
            stopLocationService();
        }else{
            getUserLocation()

        }
           return value1 + value2 + 5
       }





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

             //    sendLocationToAPIWithToken(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)


             }
         }









//     func sendLocationToAPIWithToken(latitude: Double, longitude: Double) {
//           let apiUrl = "https://next3.claims-express.net/v1/api/tema/updateGeoLocation" // Replace with your API endpoint URL
//
//           guard let url = URL(string: apiUrl) else {
//               print("Invalid API URL")
//               return
//           }
//
//         var request = URLRequest(url: url)
//              request.httpMethod = "POST"
//              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//              request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization") // Include the bearer token in the header
//
//              let parameters: [String: Any] = [
//                  "latitude": latitude,
//                  "longitude": longitude
//              ]
//
//         do {
//             request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//         } catch {
//             print("Failed to serialize JSON data: \(error)")
//             return
//         }
//
//         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//             if let error = error {
//                 print("Error sending location data to API: \(error)")
//                 return
//             }
//
//             if let data = data, let responseString = String(data: data, encoding: .utf8) {
//                 print("API Response: \(responseString)")
//             }
//         }
//
//         task.resume()
//     }


 func sendLocationToAPI() {
             print("send api")

        guard let locationManager = locationManager, let location = locationManager.location else {
            print("Location manager or location is not available")
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let apiUrl = "https://next3.claims-express.net/v1/api/tema/updateGeoLocation"
        guard let url = URL(string: apiUrl) else {
            print("Invalid API URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

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

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error sending location data to API: \(error)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }
        }.resume()
    }




    func stopLocationService() {
          if let locationManager = self.locationManager {
              locationManager.stopUpdatingLocation()
              locationManager.delegate = nil
              self.locationManager = nil
          }
      }

   }





struct TokenResponse: Codable {
    let refreshToken: String
    let token: String
}








   func registerPlugins(registry: FlutterPluginRegistry) {
     GeneratedPluginRegistrant.register(with: registry)
   }







