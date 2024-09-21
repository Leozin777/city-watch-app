import UIKit
import Flutter
import GoogleMaps
import flutterconfig

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
     application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   let key: String = FlutterConfigPlugin.env(for: "IOS_MAPS_APIKEY")
    GMSServices.provideAPIKey(key)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}