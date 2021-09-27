//
//  EventsManager.swift
//  GoldDiggerRush
//
//  Created by toha on 03.06.2021.
//

import Foundation

enum Event {
    case statusFalse, cantFetchStatus, brokenURL
}

struct EventsManager {
    
    static let shared = EventsManager()
    
    func sendEvent(_ event: Event) {
        
    }
}
