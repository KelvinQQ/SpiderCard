//
//  WaitingAreaView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/25.
//

import Cocoa

class WaitingAreaView: NSView {

    let kPadding: CGFloat = 10.0
    let kInnerMargin: CGFloat = 20.0
    
    var waitingCards: Array<Array<Card>>
    var selectedCard: CardView?
    
    var maxZIndex = 0

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    init(cardScale: CGFloat, cards: Array<Array<Card>>) {
        waitingCards = cards
        
        let columnWidth = cardScale * 71.0
        let columnHeight = cardScale * 96.0
        
        let width = columnWidth + CGFloat(cards.count - 1) * kInnerMargin
        let height = columnHeight
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        var columnX = CGFloat(0)
        let columnY = CGFloat(0)
        
        for column in cards {
            let frame = CGRect.init(x: width - columnWidth - columnX, y: columnY, width: columnWidth, height: columnHeight)
            let imageView = CardView.init(card: column[0])
            imageView.setFrame(frame: frame)
            self.addSubview(imageView)
            columnX += (kInnerMargin)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
