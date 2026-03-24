//
//  NotificationCenter.swift
//  Habit Management
//
//  Created by 한수진 on 2022/07/27.
//

import Foundation
import UserNotifications

class NotificationCenterManager {
    let userNotificationCenter = UNUserNotificationCenter.current()

    init() {
        requestNotificationAuthorization()
//        sendNotification(seconds: 10)
        print("notification init")
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "To the Deep Green"
        
        if let bodyMessege = setBodyMessage() {
            
            notificationContent.body = bodyMessege
            print(bodyMessege)
            let dateComponents = DateComponents(hour: 21, minute: 00)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "testNotification",
                                                content: notificationContent,
                                                trigger: trigger)

            userNotificationCenter.add(request) { error in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
        } else {
            userNotificationCenter.removeAllDeliveredNotifications()
        }
        print("send notification")
    }
    
    func setBodyMessage() -> String? {
        let completedHabitCount = CompletedListViewModel.shared.isTodayHabitComplete()
        let todoHabitCount = HabitViewModel.shared.getNumberOfTodayHabits()

        if (todoHabitCount - completedHabitCount) == 1 {
            return L10n.tr("notification.one_left")
        }
        if todoHabitCount == 0 {
            return nil
        }
        if todoHabitCount == completedHabitCount {
            return L10n.tr("notification.all_done")
        }
        return L10n.tr("notification.remain", todoHabitCount - completedHabitCount)
    }
    
}
