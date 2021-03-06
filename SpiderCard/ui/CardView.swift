//
//  CardView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

class CardView: NSImageView {
    
    var card: Card?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    convenience init(card: Card) {
        self.init(frame: NSRect.zero)
        self.card = card
        self.wantsLayer = true
        self.layer?.cornerRadius = 5.0
        let name = card.mode ? "CARD\(card.suit.rawValue * 13 + card.point)" : "cardback"
        self.image = NSImage.init(named: name)!
    }
    
    func transform() {
        let name = self.card!.mode ? "CARD\(self.card!.suit.rawValue * 13 + self.card!.point)" : "cardback"
        self.image = NSImage.init(named: name)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
