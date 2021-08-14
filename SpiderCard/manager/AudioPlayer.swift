//
//  AudioPlayer.swift
//  SpiderCard
//
//  Created by admin on 2021/8/1.
//

import Cocoa
import AVFoundation

enum AudioType: String {
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
    
    private lazy var player: AVPlayer = AVPlayer.init()
    private lazy var itemQueue: [AudioType] = []
    private var currentIndex = 0
    
    private static var singleton: AudioPlayer?
    
    static func instance() -> AudioPlayer {
        if singleton == nil {
            singleton = AudioPlayer()
        }
        return singleton!
    }
    
    private init() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(audioPlayDidEnd(notification:)),
                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                         object: player.currentItem)
    }
    
    func play(type: AudioType) {
        
        var canPlay = false
        
        switch type {
        case  .firework, .success:
            canPlay = Preference.instance.soundTip.contains(.success)
        case .launch:
            canPlay = Preference.instance.soundTip.contains(.start)
        case .pickup, .putdown, .deal:
            canPlay = Preference.instance.soundTip.contains(.progress)
        case .no_tip, .tip:
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
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    func play(types: [AudioType]) {
        for type in types {
            var canPlay = false
            
            switch type {
            case  .firework, .success:
                canPlay = Preference.instance.soundTip.contains(.success)
            case .launch:
                canPlay = Preference.instance.soundTip.contains(.start)
            case .pickup, .putdown, .deal:
                canPlay = Preference.instance.soundTip.contains(.progress)
            case .no_tip, .tip:
                canPlay = false
            }
            
            if !canPlay {
                return
            }
        }
        itemQueue = types
        let type = itemQueue.first!
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "wav") else {
            return
        }
        let url = URL.init(fileURLWithPath: path)
        let item = AVPlayerItem.init(url: url)
        
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    @objc func audioPlayDidEnd(notification: Notification) {
        if itemQueue.count > 1 {
            currentIndex = max((currentIndex + 1) % itemQueue.count, 1)
            play(type: itemQueue[currentIndex])
        }
    }
    
    func stop() {
        player.pause()
    }
}
