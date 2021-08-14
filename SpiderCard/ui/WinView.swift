//
//  WinView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/31.
//

import Cocoa
import CoreGraphics
import QuartzCore

class WinView: NSView {
    
    lazy var fireworksEmitter: CAEmitterLayer = CAEmitterLayer.init()

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
//        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func stopAnimation() {
        AudioPlayer.instance().stop()
        fireworksEmitter.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    
    public func startAnimation() {
        AudioPlayer.instance().play(types: [.success, .firework])
        fireworksEmitter.emitterPosition = CGPoint.init(x: self.bounds.width / 2.0, y: 0.0)
        fireworksEmitter.emitterSize = CGSize.init(width: self.bounds.width / 2.0, height: 1)
        fireworksEmitter.emitterMode = .outline
        fireworksEmitter.emitterShape = .line
        fireworksEmitter.renderMode = .additive
        fireworksEmitter.seed = arc4random() % 100 + 1
        
        let rocket = CAEmitterCell.init()
        
        rocket.birthRate        = 1
        rocket.lifetime         = 1.02
        rocket.emissionLongitude = CGFloat(Double.pi * 1)
        rocket.velocity         = 400
        rocket.velocityRange    = 50
        rocket.yAcceleration    = -5
        rocket.contents         = NSImage.init(named: "fire")?.cgImage()
        rocket.scale            = 0.2
        rocket.color            = NSColor.randomColor().cgColor
        rocket.greenRange       = 1
        rocket.redRange         = 1
        rocket.blueRange        = 1

        let fire = CAEmitterCell.init()
        fire.birthRate          = 1
        fire.velocity           = 0
        fire.scale              = 2
        fire.lifetime           = 0.1

        let spark = CAEmitterCell.init()
        spark.birthRate         = 5000
        spark.velocity          = 200
        spark.velocityRange     = 100
        spark.emissionRange     = CGFloat(2 * Double.pi)
        spark.yAcceleration     = -15
        spark.lifetime          = 3
        spark.contents          = NSImage.init(named: "fire")?.cgImage()
        spark.color             = NSColor.randomColor().cgColor
        spark.redRange          = 1.0
        spark.greenRange        = 1.0
        spark.blueRange         = 1.0
        spark.scale             = 0.25
//        spark.spin              = CGFloat(2 * Double.pi)
//        spark.spinRange         = CGFloat(2 * Double.pi)

        fireworksEmitter.emitterCells   = [rocket]
        rocket.emitterCells             = [fire]
        fire.emitterCells              = [spark]
        self.layer?.addSublayer(fireworksEmitter)
    }
}
