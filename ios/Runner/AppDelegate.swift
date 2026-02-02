import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, NotificationApi, NotificationPermissionApi {
    var callbackApi: NotificationCallbackApi?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Pigeon Setup
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let binaryMessenger = controller.binaryMessenger
        NotificationApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        NotificationPermissionApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        callbackApi = NotificationCallbackApi(binaryMessenger: binaryMessenger)
        
        UNUserNotificationCenter.current().delegate = self

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - NotificationApi
    func showNotification(payload: NotificationPayload) throws {
        let content = UNMutableNotificationContent()
        content.title = payload.title ?? "Notification"
        content.body = payload.body ?? ""
        content.sound = UNNotificationSound.default
        
        if let postId = payload.postId {
            content.userInfo = ["postId": postId]
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - NotificationPermissionApi
    func requestPermission(completion: @escaping (Result<Bool, Error>) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(granted))
            }
        }
    }

    func checkPermission() throws -> Bool {
        return true 
    }

    // MARK: - UNUserNotificationCenterDelegate
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let postId = userInfo["postId"] as? Int64 {
            callbackApi?.onNotificationTapped(postId: postId) { _ in }
        }
        completionHandler()
    }
}
