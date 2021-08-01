//
//  DeskAreaView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

protocol DeskAreaViewDelegate: class {
    func didFinish()
}

class DeskAreaView: NSView {
    
    var cards: Array<Array<Card>>?
    var waitingAreaRect: CGRect?
    
    weak var delegate: DeskAreaViewDelegate?
    
    var columnFrames: Array<NSRect> = []
    var selectedInfo: (columnIndex: Int, cardIndex: Int)?
    var deskCardViews: Array<Array<CardView>> = []

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    init(frame: NSRect, cards: Array<Array<Card>>) {

        super.init(frame: frame)
        self.cards = cards
        self.wantsLayer = true
//        self.layer?.backgroundColor = NSColor.red.cgColor
        
        reloadData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        
        guard let cards = self.cards else {
            return
        }
        deskCardViews.removeAll()
        columnFrames.removeAll()
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    
        let margin = (frame.size.width - 10 * Const.CARD_WIDTH - Const.LEFT_MARGIN - Const.RIGHT_MARGIN) / 9.0
        let columnHeight = frame.size.height
        var columnX = CGFloat(Const.LEFT_MARGIN)
        let columnY = CGFloat(0)
        
        for column in cards {
            let frame = CGRect.init(x: columnX, y: columnY, width: Const.CARD_WIDTH, height: columnHeight)
            let emptyImageView = NSImageView.init()
            emptyImageView.frame = CGRect.init(x: columnX, y: columnHeight - Const.CARD_HEIGHT - Const.TOP_MARGIN,
                                               width: Const.CARD_WIDTH, height: Const.CARD_HEIGHT)
            emptyImageView.wantsLayer = true
            emptyImageView.layer?.borderColor = NSColor.white.cgColor
            emptyImageView.layer?.borderWidth = 1.0
            emptyImageView.layer?.cornerRadius = 5.0
            self.addSubview(emptyImageView)
            
            setupColumnCard(frame: frame, cards: column)
            columnFrames.append(frame)
            columnX += (margin + Const.CARD_WIDTH)
        }
    }
    
    func setupColumnCard(frame: NSRect, cards: Array<Card>) {
        let x: CGFloat = frame.origin.x
        var y: CGFloat = frame.height - Const.CARD_HEIGHT - Const.TOP_MARGIN
        var frames: Array<NSRect> = []
        var views: Array<CardView> = []
        for (index, card) in cards.enumerated() {
            let imageView = CardView.init(card: card)
            imageView.layer?.zPosition = CGFloat(index)
            let frame = CGRect.init(x: x, y: y, width: Const.CARD_WIDTH, height: Const.CARD_HEIGHT)
            frames.append(frame)
            views.append(imageView)
            imageView.setFrame(frame: frame)
            self.addSubview(imageView)
            if card.mode {
                y -= Const.VERTICAL_CARD_INNER_MARGIN_BIG
            } else {
                y -= Const.VERTICAL_CARD_INNER_MARGIN_SMALL
            }
            
        }
        deskCardViews.append(views)
    }
    
    
    /// 鼠标事件
    override func mouseDown(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        if let contain = waitingAreaRect?.contains(location), contain {
            super.mouseDown(with: event)
            return
        }
        
        guard let tmp = indexBy(point: location) else {
            return
        }
        
        if !GameManager.instance().canPicker(from: tmp.columnIndex, index: tmp.cardIndex) {
            return
        }
        
        AudioPlayer.instance().play(type: .pickup)
        
        self.selectedInfo = tmp

        let cards = selectedCardViews(selectedIndex: self.selectedInfo!)
        for (index, item) in cards.enumerated() {
            item.layer?.zPosition = CGFloat(999 + index)
        }
        
    }
    
    override func mouseDragged(with event: NSEvent) {

        guard let selected = self.selectedInfo else {
            return
        }
        let cards = selectedCardViews(selectedIndex: selected)
        for item in cards {
            item.setFrameOrigin(NSPoint.init(x: item.frame.origin.x + event.deltaX, y: item.frame.origin.y - event.deltaY))
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        if let contain = waitingAreaRect?.contains(location), contain {
            super.mouseUp(with: event)
            return
        }
        
        
        guard let selected = self.selectedInfo else {
            return
        }
        
        AudioPlayer.instance().play(type: .putdown)
        
        guard let columnIndex = columnOfPoint(point: location) else {
            resetPosition()
            return
        }
        
        guard selected.columnIndex != columnIndex else {
            resetPosition()
            return
        }
        
        if !GameManager.instance().move(from: selected.columnIndex, to: columnIndex, index: selected.cardIndex) {
            resetPosition()
            return
        }
        
        let lastCard = lastCardViewOf(columnIndex: columnIndex)
        let lastFrame = lastCard?.frame
        var origin = CGPoint.init(x: columnFrames[columnIndex].origin.x, y: columnFrames[columnIndex].height - Const.CARD_HEIGHT - Const.TOP_MARGIN)
        if lastFrame != nil {
            origin =  CGPoint.init(x: lastFrame!.origin.x, y: lastFrame!.origin.y - Const.VERTICAL_CARD_INNER_MARGIN_BIG)
        }
        
        let cards = selectedCardViews(selectedIndex: selected)
        for (index, item) in cards.enumerated() {
            let zPosition = lastCard?.layer?.zPosition ?? 0
            item.layer?.zPosition = zPosition + CGFloat(index + 1)
            item.setFrameOrigin(NSPoint.init(x: origin.x, y: origin.y - CGFloat(index) * Const.VERTICAL_CARD_INNER_MARGIN_BIG))
        }
        selectedInfo = nil
        deskCardViews[columnIndex].append(contentsOf: cards)
        deskCardViews[selected.columnIndex].removeSubrange(selected.cardIndex...)
        
        if GameManager.instance().transform(column: selected.columnIndex) {
            deskCardViews[selected.columnIndex].last!.transform()
        }
        
        if GameManager.instance().finish(column: columnIndex) {
            // 收牌
            self.cards = GameManager.instance().deskAreaCards
            reloadData()
            delegate?.didFinish()
            
            if GameManager.instance().transform(column: columnIndex) {
                deskCardViews[columnIndex].last!.transform()
            }
        }
        
    }
    
    func columnOfPoint(point: CGPoint) -> Int? {
        var columnIndex: Int?
        for i in 0..<columnFrames.count {
            let column = columnFrames[i]
            if column.contains(point) {
                columnIndex = i
                break
            }
        }
        return columnIndex
    }
    
    func cardByPoint(point: CGPoint) -> (Int?, Int?, CardView?) {
        let columnIndex = columnOfPoint(point: point)
        var selectedCard: CardView?
        var selectedCardIndex: Int?
        
        if columnIndex == nil {
            return (columnIndex, selectedCardIndex, selectedCard)
        }
        
        for (index, item) in self.subviews.enumerated().reversed() {
            if item.frame.contains(point) {
                selectedCard = item as? CardView
                selectedCardIndex = index
                break
            }
        }
        return (columnIndex, selectedCardIndex, selectedCard)
    }
    
    func resetPosition() {
        
        guard let selected = self.selectedInfo else {
            return
        }
        var origin = CGPoint.init(x: 0, y: 0)
        let lastCard = cardViewOf(columnIndex: selected.columnIndex, cardIndex: max(selected.cardIndex - 1, 0))
        let lastMode = lastCard?.card?.mode ?? false
        let lastFrame = lastCard?.frame
        if lastFrame != nil {
            origin =  CGPoint.init(x: lastFrame!.origin.x, y: lastFrame!.origin.y - (lastMode ? Const.VERTICAL_CARD_INNER_MARGIN_BIG : Const.VERTICAL_CARD_INNER_MARGIN_SMALL))
        }
        
        let cards = selectedCardViews(selectedIndex: selected)
        for (index, item) in cards.enumerated() {
            let zPosition = lastCard?.layer?.zPosition ?? 0
            item.layer?.zPosition = zPosition + CGFloat(index + 1)
            item.setFrameOrigin(NSPoint.init(x: origin.x, y: origin.y - CGFloat(index) * Const.VERTICAL_CARD_INNER_MARGIN_BIG))
        }
        selectedInfo = nil
    }
    
    /// 鼠标点击的卡牌
    /// - Parameter point: 坐标
    /// - Returns: 列和卡牌序号
    func indexBy(point: CGPoint) -> (columnIndex: Int, cardIndex: Int)? {
        for i in 0..<deskCardViews.count {
            for j in (0..<deskCardViews[i].count).reversed() {
                if deskCardViews[i][j].frame.contains(point) {
                    return (i, j)
                }
            }
        }
        return nil
    }
    func selectedCardViews(selectedIndex: (columnIndex: Int, cardIndex: Int)) -> Array<CardView> {
        return Array.init(deskCardViews[selectedIndex.columnIndex][selectedIndex.cardIndex...])
    }
    func cardViewOf(columnIndex: Int, cardIndex: Int) -> CardView? {
        if columnIndex > deskCardViews.count {
            return nil
        }
        if cardIndex > deskCardViews[columnIndex].count {
            return nil
        }
        return deskCardViews[columnIndex][cardIndex]
    }
    func lastCardViewOf(columnIndex: Int) -> CardView? {
        return deskCardViews[columnIndex].last
    }
    
    func setWaitingAreaRect(rect: CGRect) {
        waitingAreaRect = rect
    }
}
