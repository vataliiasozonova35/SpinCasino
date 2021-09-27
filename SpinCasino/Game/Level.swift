//
//  Level.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 19.08.2021.
//

import UIKit

class Level {
    static let shared = Level()
    static let maxRateLevel: Float = 50
    
    //level:
    let levelKey = "LEVEL"
    var level: Int {
        get {
            return UserDefaults.standard.integer(forKey: levelKey)
        }
        set {
            guard newValue > 0 else {
                return
            }
            guard newValue > level else {
                return
            }
            UserDefaults.standard.set(newValue, forKey: levelKey)
        }
    }
    //shared level:
    let sharedKey = "SharedKEY"
    var rateLevel: Float {
        get {
            return UserDefaults.standard.float(forKey: sharedKey)
        }
        set {
            guard newValue > 0 else {
                return
            }
            UserDefaults.standard.set(newValue, forKey: sharedKey)
        }
    }
    //coins:
    let coinsKey = "CoinsKey"
    var coinsPool: Int {
        get {
            return UserDefaults.standard.integer(forKey: coinsKey)
        }
        set {
            guard newValue > 0 else {
                return
            }
            UserDefaults.standard.set(newValue, forKey: coinsKey)
        }
    }
    let bonusKey = "bonusKey"
    
    var getBonus: Bool {
        get {
            return UserDefaults.standard.bool(forKey: bonusKey)
        }
        set {
            UserDefaults.standard.setValue(true, forKey: bonusKey)
        }
    }
    let musicKey = "musicKey"
    
    var musicOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: musicKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: musicKey)
        }
    }
    
    init() {
        UserDefaults.standard.register(defaults: [levelKey : 1])
        UserDefaults.standard.register(defaults: [sharedKey: 0])
        UserDefaults.standard.register(defaults: [coinsKey: 1000])
        UserDefaults.standard.register(defaults: [bonusKey: false])
        UserDefaults.standard.register(defaults: [musicKey: false])
    }
}
