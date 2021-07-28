//
//  CardQueueView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

enum Orientation {
    case horization
    case vertical
}

class CardQueueView: NSView {
    
    var orientation: Orientation = .horization

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    init(cards: Array<Card>, orientation: Orientation) {
        super.init(frame: NSRect.zero)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
        
        self.orientation = orientation
        var lastXAnchor = self.leftAnchor
        var lastYAnchor = self.topAnchor
        var lastImageView = CardView.init()
        for card in cards {
            let imageView = CardView.init(card: card)
            self.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            if orientation == .horization {
                imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                imageView.leftAnchor.constraint(equalTo: lastXAnchor, constant: 20).isActive = true
                lastXAnchor = imageView.leftAnchor
            } else {
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                imageView.topAnchor.constraint(equalTo: lastYAnchor, constant: 20).isActive = true
                lastYAnchor = imageView.topAnchor
            }
            lastImageView = imageView
        }
        if orientation == .horization {
            lastImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        } else {
            lastImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        }
        
    }
   
    convenience init(cards: Array<Card>) {
        self.init(cards: cards, orientation: .horization)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
