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

struct SoundTip: OptionSet {
    var rawValue: UInt

    static let start            = SoundTip(rawValue: 1 << 0)
    static let progress         = SoundTip(rawValue: 1 << 1)
    static let success          = SoundTip(rawValue: 1 << 2)
    static let all: SoundTip    = [.start, .progress, .success]
}


struct Preference {
    
    var soundTip: SoundTip = SoundTip.init(rawValue: UInt(UserDefaults.standard.integer(forKey: "SOUND_TIP")))
    var difficult: Difficult = Difficult(rawValue: UserDefaults.standard.integer(forKey: "DIFFICULT"))
    
    var background: String = UserDefaults.standard.string(forKey: "BACKGROUND") ?? "background"
    
    func save() {
        UserDefaults.standard.setValue(background, forKey: "BACKGROUND")
        UserDefaults.standard.setValue(soundTip.rawValue, forKey: "SOUND_TIP")
        UserDefaults.standard.setValue(difficult.rawValue, forKey: "DIFFICULT")
        UserDefaults.standard.synchronize()
    }
    
    static var instance = Preference()
    
    private init() {
        
    }
}
