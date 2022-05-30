//
//  UserDefaultsManager.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation

class UserDefaultsManager {
    
    private let userDefaults = UserDefaults.standard
    static var shared = UserDefaultsManager()
    
    private init () { }
    
    private let saveSinceValue = "since.json"
    
    func saveLastSinceValue(_ since: Int) {
        userDefaults.setValue(since, forKey: saveSinceValue)
        userDefaults.synchronize()
    }

    func getSinceValue() -> Int {
        return userDefaults.integer(forKey: saveSinceValue)
    }
}
