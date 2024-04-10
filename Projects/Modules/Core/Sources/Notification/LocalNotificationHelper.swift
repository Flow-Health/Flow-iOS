// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import UserNotifications

public class LocalNotificationHelper {
    public static let shared = LocalNotificationHelper()
    
    private init() { }

    public func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
