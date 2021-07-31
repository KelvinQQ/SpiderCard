//
//  Preference.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

enum Difficult: Int {
    case easy = 11
    case middle
    case hard
    
    init(rawValue: Int) {
        switch rawValue {
        case 11:
            self = .easy
        case 12:
            self = .middle
        case 13:
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
        UserDefaults.standard.synchronize()
    }
    
    static var instance = Preference()
    
    private init() {
        
    }
}
