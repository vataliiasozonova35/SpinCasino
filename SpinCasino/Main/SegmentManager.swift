//
//  SegmentManager.swift
//  JohnnyCashUp
//
//  Created by toha on 22.04.2021.
//

import Foundation
import Firebase

struct SegmentManager {
    
    static func handlePushNotification(_ userInfo: [AnyHashable : Any]) {
        if let event = userInfo["event"] as? String {
            switch event {
            case "reg", "registration":
                UserDefaultsManager.didReg = true
                SegmentManager.handleReg()
//                OneSignal.sendTag("reg", value: "true")
            case "dep":
                SegmentManager.handleDep()
//                OneSignal.sendTag("dep", value: "true")
            default:
                print("Unknown event")
            }
        } else {
            print("Notification badly formatted", userInfo)
        }
    }
    
    static func handleReg() {
        Messaging.messaging().subscribe(toTopic: "reg") {
            print($0 ?? "subscribe to reg")
        }
    }
    
    static func handleDep() {
        UserDefaultsManager.depCount += 1
        let depCount = UserDefaultsManager.depCount
        switch depCount {
        case 1:
            Messaging.messaging().subscribe(toTopic: "dep")  {
                print($0 ?? "subscribed to dep")
            }
            Messaging.messaging().subscribe(toTopic: "dep_1")  {
                print($0 ?? "subscribed to dep_1")
            }
        case 2...4:
            Messaging.messaging().unsubscribe(fromTopic: "dep_\(depCount - 1)")  {
                print($0 ?? "unsubscribed to dep_\(depCount - 1)")
            }
            Messaging.messaging().subscribe(toTopic: "dep_\(depCount)")  {
                print($0 ?? "subscribed to dep_\(depCount)")
            }
        case 5:
            Messaging.messaging().unsubscribe(fromTopic: "dep_\(depCount - 1)")  {
                print($0 ?? "unsubscribed dep_\(depCount - 1)")
            }
            Messaging.messaging().subscribe(toTopic: "dep_mult")  {
                print($0 ?? "subscribed to dep_mult")
            }
        default:
            break
        }
    }
}
