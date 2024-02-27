import UIKit
import Flutter
import Firebase
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {

    private var bearerToken: String = ""
    private var myRefreshToken: String = ""
    private var locationManager: CLLocationManager?
    private var timer: Timer?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "FlutterFramework/swift_native", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getSum" {
                let args = call.arguments as? [String: Any] ?? [:]

                if let value1 = args["value1"] as? Int,
                   let value2 = args["value2"] as? Int,
                   let token = args["token"] as? String,
                   let refreshToken = args["refreshToken"] as? String {
                    self?.bearerToken = token
                    self?.myRefreshToken = refreshToken
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
        registerForRemoteNotifications(application: application)
        startTimer()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func registerForRemoteNotifications(application: UIApplication) {
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        // Fire the timer immediately upon starting
        timer?.fire()
    }

    @objc func timerFired() {
        getRefreshToken()
        sendLocationToAPI()
    }

    private func getSum(value1: Int, value2: Int) -> Int {
        if value1 == 0 {
            stopLocationService()
        } else {
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
        // No need to handle location updates here
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
            } catch {
                print("Error decoding token response: \(error)")
            }
        }.resume()
    }

    func sendLocationToAPI() {
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
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
        locationManager = nil
    }
}

struct TokenResponse: Codable {
    let refreshToken: String
}
