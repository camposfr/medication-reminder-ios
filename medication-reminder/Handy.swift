//
//  Handy.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-08-31.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

// MARK: - Convert sDate to a String of any Date Format
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

// MARK: - Converts String to Date of current timezone
extension String
{
    var toDate: Date?
    {
        let date = DateFormatter()
        date.timeZone = TimeZone.current
        date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return date.date(from: self)
    }
}


//Create Notifications
/// Create Local Notifications
///
/// - Parameters:
///   - title: Title for Notification
///   - subTitle: Subtitle for Notification
///   - body: The message of the Notification
///   - id: Unique id of the Notification
///   - date: Timestamp date for certain Notification
func addNotification(title: String, subTitle: String, body: String, id: String, date: Date)
{
    let content = UNMutableNotificationContent()
    content.sound = UNNotificationSound(named: "pills.aiff")
    content.title = title
    content.subtitle = subTitle
    content.body = body
    content.badge = 1
    let Date = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: Date, repeats: false)
    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (Error) in
        if let error = Error
        {
            print(error)
        }
    })
}


