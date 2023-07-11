import Flutter
import UIKit

public final class SwiftAppLinksPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  private var initialLink: String?
  private var latestLink: String?
  private var referrerURLStr: String?
  private var parameters: [String: Any]?

    public static func applicationDidFinishLaunching(_ userActivity: NSUserActivity) {
        switch userActivity.activityType {
          case NSUserActivityTypeBrowsingWeb:
            guard let url = userActivity.webpageURL else {
              return
            }
            let referrerURLStr = userActivity.referrerURL?.absoluteString
            let link = url.absoluteString
            SwiftAppLinksIntercept().initialLink = link
            SwiftAppLinksIntercept().referrerURLStr = referrerURLStr
          default:
            break
        }
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "com.llfbandit.app_links/messages", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "com.llfbandit.app_links/events", binaryMessenger: registrar.messenger())

    let instance = SwiftAppLinksPlugin()

    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getInitialAppLink":
        result(initialLink)
      case "getLatestAppLink":
        result(latestLink)
    case "getInitialReferrerURL":
        let para = parameters ?? ["link": initialLink ?? SwiftAppLinksIntercept().initialLink, "referrerURL": referrerURLStr ?? SwiftAppLinksIntercept().referrerURLStr]
        result(para)
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  // Universal Links
  public func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([Any]) -> Void) -> Bool {

    switch userActivity.activityType {
      case NSUserActivityTypeBrowsingWeb:
        guard let url = userActivity.webpageURL else {
          return false
        }
        referrerURLStr = userActivity.referrerURL?.absoluteString
        handleLink(url: url)
        return false
      default: return false
    }
  }

  // Custom URL schemes
  public func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
    handleLink(url: url)
    return false
  }
    
  public func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink) -> FlutterError? {

    self.eventSink = events
    return nil
  }
    
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  private func handleLink(url: URL) -> Void {
    let link = url.absoluteString

    print("iOS handleLink: \(link)")

    latestLink = link

    if (initialLink == nil) {
      initialLink = link
    }

    guard let _eventSink = eventSink, latestLink != nil else {
      return
    }

//    _eventSink(latestLink)
     parameters = ["link": latestLink, "referrerURL": referrerURLStr]
     _eventSink(parameters)
  }
}

class SwiftAppLinksIntercept {
  static let shared = SwiftAppLinksIntercept()
  var initialLink: String?
  var referrerURLStr: String?
}
