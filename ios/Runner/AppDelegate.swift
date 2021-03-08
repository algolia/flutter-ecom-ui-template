import UIKit
import Flutter
import AlgoliaSearchClient

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  let algoliaAdapter = AlgoliaAPIFlutterAdapter(applicationID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let algoliaAPIChannel = FlutterMethodChannel(name: "com.algolia/api", binaryMessenger: controller.binaryMessenger)
    algoliaAPIChannel.setMethodCallHandler(algoliaAdapter.perform(call:result:))
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}

class AlgoliaAPIFlutterAdapter {
  
  let applicationID: ApplicationID
  let apiKey: APIKey
  
  init(applicationID: ApplicationID, apiKey: APIKey) {
    self.applicationID = applicationID
    self.apiKey = apiKey
  }
  
  func perform(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "search":
      if let arguments = call.arguments as? [String] {
        search(indexName: IndexName(rawValue: arguments[0]), query: arguments[1], completion: result)
      } else {
        result(FlutterError(code: "AlgoliaNativeError", message: "Missing arguments", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  func search(indexName: IndexName, query: String, completion: @escaping FlutterResult) {
    SearchClient(appID: applicationID, apiKey: apiKey)
      .index(withName: indexName)
      .search(query: "\(query)") { result in
        switch result {
        case .success(let response):
          let data = try! JSONEncoder().encode(response)
          let jsonString = String(data: data, encoding: .utf8)
          completion(jsonString)
        case .failure(let error):
          completion(FlutterError(code: "AlgoliaNativeError", message: error.localizedDescription, details: nil))
        }
    }
  }
  
}

