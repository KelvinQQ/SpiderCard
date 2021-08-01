//
//  AudioPlayer.swift
//  SpiderCard
//
//  Created by admin on 2021/8/1.
//

import Cocoa
import AVFoundation

enum AutioType: String {
    case deal
    case pickup
    case putdown
    case tip
    case no_tip
    case launch
    case success
    case firework
}

class AudioPlayer {
    
    private var player: AVPlayer?
    
    private static var singleton: AudioPlayer?
    
    static func instance() -> AudioPlayer {
        if singleton == nil {
            singleton = AudioPlayer()
        }
        return singleton!
    }
    
    private init() {
        
    }
    
    func play(type: AutioType) {
        
        var canPlay = false
        
        switch type {
        case .success:
            canPlay = Preference.instance.soundTip.contains(.success)
        case .launch:
            canPlay = Preference.instance.soundTip.contains(.start)
        case .pickup, .putdown, .deal:
            canPlay = Preference.instance.soundTip.contains(.progress)
        case .firework, .no_tip, .tip:
            canPlay = false
        }
        
        if !canPlay {
            return
        }
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "wav") else {
            return
        }
        
        let url = URL.init(fileURLWithPath: path)
        
        let item = AVPlayerItem.init(url: url)
        if player == nil {
            player = AVPlayer.init()
        }
        
        player!.pause()
        player!.replaceCurrentItem(with: item)
        player!.play()
        
    }
}