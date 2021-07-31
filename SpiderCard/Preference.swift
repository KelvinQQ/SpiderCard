//
//  Preference.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

enum Difficult: Int {
    case easy = 1
    case middle
    case hard
    
    init(rawValue: Int) {
        let value = (rawValue - 10) % 3
        switch value {
        case 1:
            self = .easy
        case 2:
            self = .middle
        case 3:
            self = .hard
        default:
            self = .easy
        }
    }
}
struct Preference {
    var difficult: Difficult = Difficult(rawValue: UserDefaults.standard.integer(forKey: "DIFFICULT")) 
    func save() {
        UserDefaults.standard.setValue(difficult.rawValue, forKey: "DIFFICULT")
    }
    
    static var instance = Preference()
    
    private init() {
        
    }
}
