//
//  Checker.swift
//  Wild Melody
//
//  Created by Book of Dead on 10/11/2020.
//

import UIKit
import Firebase
import FirebaseAnalytics
import AppsFlyerLib
//import OneSignal

class Checker {
    
    // get home or track if it's stored
    static var savedHomeTrack: URL? {
        let homeURL = UserDefaultsManager.home
        let trackURL = UserDefaultsManager.track
        
        if UserDefaultsManager.didReg {
            return homeURL
        } else {
            return trackURL
        }
    }
    
    private init() {}
    static let shared = Checker()
    
    func checkEveryting(completion: @escaping (_ url: URL?) -> ()) {
//        let appsflyerId = AppsFlyerLib.shared().getAppsFlyerUID()
//        print(appsflyerId)
        
        if let url = Checker.savedHomeTrack {
            completion(url)
            return
        }
        
        print("getting status...")
        getState { (status) in
            print("status is \(status)")
            switch status {
            case "open":
                self.getTrackUrl(forCompaign: UserDefaultsManager.compaign, completion: completion)
            case "real":
                if let compaign = UserDefaultsManager.compaign {
                    self.getTrackUrl(forCompaign: compaign, completion: completion)
                } else {
                    completion(nil)
                }
            default:
                completion(nil)
            }
        }
        
    }
        
    func getTrackUrl(forCompaign compaign: String?, completion: @escaping (_ url: URL?) -> ()) {
        
        Messaging.messaging().token { (result, error) in
            if let err = error { print(err) }

            guard let firebaseID = result else {
                print("FirebaseID is nil")
                Analytics.logEvent("noFirebaseId", parameters: [:])
                completion(nil)
                return
            }

            self.getStatus(compaign: compaign, firebaseID: firebaseID) { (status, home, track) in
                if status == true {
                    guard let homeURL = home, let trackURL = track else { return }
                    UserDefaultsManager.home = homeURL
                    UserDefaultsManager.track = trackURL
                    completion(track)
                } else {
                    Analytics.logEvent("gotStatusFalse", parameters: [
                        "compaign" : UserDefaultsManager.compaign ?? "nil",
                        "loacale" : Locale.current.description
                    ])
                    completion(nil)
                }
            }
        }
    }
    
    func getStatus(compaign: String?, firebaseID: String, completion: @escaping (_ status: Bool, _ home: URL?, _ track: URL?) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Consts.dynamicTutorial
        urlComponents.path = "/prod"
        
        let appsflyerId = AppsFlyerLib.shared().getAppsFlyerUID()
        urlComponents.queryItems = [
            URLQueryItem(name: "uuid", value: firebaseID),
            URLQueryItem(name: "uid", value: appsflyerId),
            URLQueryItem(name: "app", value: Consts.appID)
        ]
        
        if let compaign = compaign {
            let components = compaign.components(separatedBy: "_")
            if components.count > 3 {
                urlComponents.queryItems?.append(contentsOf: [
                    URLQueryItem(name: "a", value: components[1]),
                    URLQueryItem(name: "o", value: components[2]),
                    URLQueryItem(name: "s3", value: components[3]),
                ])
            }
        }
        
        guard let url = urlComponents.url else { return }
        print("Get request to: ", url)
        var status = false
        var home: URL?
        var track: URL?
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data else {
                print(error?.localizedDescription ?? "Response Error")
                completion(status, nil, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [String: Any] {
                    // Reading from JSON
                    if
                        let gotStatus = json["status"] as? Bool,
                        let gotHome = json["home"] as? String,
                        let gotTrack = json["track"] as? String
                    {
                        print("gotHome: ", gotHome)
                        print("gotTrack: ", gotTrack)
                        status = gotStatus
                        home = URL(string: gotHome)
                        track = URL(string: gotTrack)
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            completion(status, home, track)
        }
        task.resume()
    }
    
    func sendToServer(mail: String) {
        //Send reg event
        UserDefaultsManager.didReg = true
//        OneSignal.sendTag("reg", value: "true")
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Consts.dynamicTutorial
        urlComponents.path = "/prod/acc"
        urlComponents.queryItems = [
            URLQueryItem(name: "user", value: mail),
            URLQueryItem(name: "app", value: Consts.appID)
        ]
        guard let url = urlComponents.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let resp = response as? HTTPURLResponse else { return }
            if resp.statusCode == 200 {
                //print("\(mail) submitted successfully")
            } else {
                print("Error: ", resp)
            }
        }
        task.resume()
    }
    
    func getState(completion: @escaping (_ isOpen: String) -> ()) {
        let ref = Database.database(url: "https://spincasino-8020f-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        ref.child("status").getData { (error, snapshot) in
            if let value = snapshot.value as? String {
                completion(value)
            } else {
                print("can't fetch is opened value")
                completion("")
            }
        }
    }
    
}
