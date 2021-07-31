//
//  FinishedAreaView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/30.
//

import Cocoa

class FinishedAreaView: NSView {
    
    var finishedCards: Array<Array<Card>>?
    
    let kPadding: CGFloat = 10.0
    let kInnerMargin: CGFloat = 20.0
    
    var cardScale: CGFloat = 1.0

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func reloadData() {
        guard let cards = finishedCards else {
            return
        }
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let columnWidth = cardScale * Const.CARD_WIDTH
        let columnHeight = cardScale * Const.CARD_HEIGHT
        
        var columnX = CGFloat(0)
        let columnY = CGFloat(0)
        
        for column in cards {
            let frame = CGRect.init(x: 0 + columnX, y: columnY, width: columnWidth, height: columnHeight)
            if column.count == 0 {
                continue
            }
            let imageView = CardView.init(card: column[0])
            imageView.setFrame(frame: frame)
            self.addSubview(imageView)
            columnX += (kInnerMargin)
        }
    }
    
    init(cardScale: CGFloat, cards: Array<Array<Card>>) {
        self.finishedCards = cards
        self.cardScale = cardScale
        
        let columnWidth = cardScale * Const.CARD_WIDTH
        let columnHeight = cardScale * Const.CARD_HEIGHT
        
        let width = columnWidth + CGFloat(7) * kInnerMargin
        let height = columnHeight
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        self.wantsLayer = true
//        self.layer?.backgroundColor = NSColor.red.cgColor
        
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
