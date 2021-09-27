//
//  UserDefaultsManager.swift
//  Wild Melody
//
//  Created by Book of Dead on 10/11/2020.
//

import Foundation

// TODO: Prorety wrapers
struct UserDefaultsManager {
    
    static func reg() {
        UserDefaults.standard.register(defaults: ["didReg" : false])
        UserDefaults.standard.register(defaults: ["best" : 0])
        UserDefaults.standard.register(defaults: ["depCount" : 0])
        UserDefaults.standard.register(defaults: ["isFirstLaunch" : true])
        UserDefaults.standard.register(defaults: ["LevelChoose" : 0])
        UserDefaults.standard.register(defaults: ["imageCounts" : 3])
    }
    
    static var compaign: String? {
        get {
            return UserDefaults.standard.string(forKey: "compaign")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "compaign")
        }
    }
    
    static var home: URL? {
        get {
            return UserDefaults.standard.url(forKey: "home")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "home")
        }
    }
    
    static var track: URL? {
        get {
            return UserDefaults.standard.url(forKey: "track")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "track")
        }
    }
    
    static var didReg: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didReg")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "didReg")
        }
    }
    
    static var depCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "depCount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "depCount")
        }
    }
    
    static var LevelChoose: Int {
        get {
            return UserDefaults.standard.integer(forKey: "levelChoose")
        }
        set {
            UserDefaults.standard.set(newValue,forKey: "levelChoose")
        }
    }
    
    static var imageCounts: Int {
        get {
            return UserDefaults.standard.integer(forKey: "imageCounts")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "imageCounts")
        }
    }
    
    static var aff_sub3: String? {
        if let compaign = UserDefaultsManager.compaign {
            let components = compaign.components(separatedBy: "_")
            let count = components.count
            let aff = count > 1 ? components[1] : ""
            let sub3 = count > 3 ? components[3] : ""
            let aff_sub3 = aff + "_" + sub3
            if aff_sub3 != "_" {
                return aff_sub3
            } else {
                return ""
            }
        } else {
            return nil
        }
    }
    
}
