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
        let numOfcompletedHabit = compltedLIstVM.shared.isTodayHabitComplete()
        let numOfTodoHabit = HabitVM.shared.getNumOfTodayHabit()
        
        if (numOfTodoHabit-numOfcompletedHabit) == 1 {
            return "1개만 더 완료하면 모든 습관을 완료할 수 있어요!"
        }
        if numOfTodoHabit == 0 {
            return nil
        }
        if numOfTodoHabit == numOfcompletedHabit {
            return "오늘 에정된 모든 습관을 완료했어요! 내일도 화이팅!"
        }
        return "오늘 미달성한 목표가 \(numOfTodoHabit-numOfcompletedHabit)개 남았어요!"
    }
    
}
