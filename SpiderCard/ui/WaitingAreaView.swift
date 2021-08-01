//
//  WaitingAreaView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/25.
//

import Cocoa

protocol WaitingAreaViewDelegate: class {
    func didDeal()
}

class WaitingAreaView: NSView {
    
    var waitingCards: Array<Array<Card>>?
    var selectedCard: CardView?
    
    weak var delegate: WaitingAreaViewDelegate?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func reloadData() {
        
        guard let cards = waitingCards else {
            return
        }
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let columnWidth = Const.CARD_WIDTH
        let columnHeight = Const.CARD_HEIGHT
        
        var columnX = CGFloat(0)
        let columnY = CGFloat(0)
        
        let width = self.bounds.width
        
        for column in cards {
            let frame = CGRect.init(x: width - columnWidth - columnX, y: columnY, width: columnWidth, height: columnHeight)
            let imageView = CardView.init(card: column[0])
            imageView.setFrame(frame: frame)
            self.addSubview(imageView)
            columnX += (Const.HORIZONTAL_CARD_INNER_MARGIN_SMALL)
        }
    }
    
    init(cards: Array<Array<Card>>) {
        self.waitingCards = cards
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: Const.WAITING_AREA_VIEW_WIDTH, height: Const.WAITING_AREA_VIEW_HEIGHT))
        self.wantsLayer = true
//        self.layer?.backgroundColor = NSColor.red.cgColor
        
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseUp(with event: NSEvent) {
        if GameManager.instance().deal() , let delegate = self.delegate {
            delegate.didDeal()
            self.waitingCards = GameManager.instance().waittingAreaCards
            reloadData()
        }
    }
    
}
