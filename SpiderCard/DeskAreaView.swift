//
//  DeskAreaView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

class DeskAreaView: NSView {
    
    var cardScale: CGFloat = 1.0
    let kPadding: CGFloat = 10.0
    let kInnerMargin: CGFloat = 20.0
    
    var columnFrames: Array<NSRect> = []
    var selectedInfo: (columnIndex: Int, cardIndex: Int)?
    var deskCardViews: Array<Array<CardView>> = []

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    init(frame: NSRect, cards: Array<Array<Card>>) {

        deskCardViews.removeAll()
        columnFrames.removeAll()
        
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let columnWidth = (frame.size.width - CGFloat(2 * kPadding + 9 * kInnerMargin)) / 10.0
        let columnHeight = frame.size.height
        var columnX = CGFloat(kPadding)
        let columnY = CGFloat(0)
        
        for column in cards {
            let frame = CGRect.init(x: columnX, y: columnY, width: columnWidth, height: columnHeight)
            setupColumnCard(frame: frame, cards: column)
            columnFrames.append(frame)
            columnX += (kInnerMargin + columnWidth)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupColumnCard(frame: NSRect, cards: Array<Card>) {
        let scale = frame.width / 71.0
        cardScale = scale
        let width = CGFloat(71.0 * scale)
        let height = CGFloat(96.0 * scale)
        let x: CGFloat = frame.origin.x
        var y: CGFloat = frame.height - height
        var frames: Array<NSRect> = []
        var views: Array<CardView> = []
        for (index, card) in cards.enumerated() {
            let imageView = CardView.init(card: card)
            imageView.layer?.zPosition = CGFloat(index)
            let margin: CGFloat = 20.0
            let frame = CGRect.init(x: x, y: y, width: width, height: height)
            frames.append(frame)
            views.append(imageView)
            imageView.setFrame(frame: frame)
            self.addSubview(imageView)
            y -= margin
        }
        deskCardViews.append(views)
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        print("mouseDown \(location)")
        
        guard let tmp = indexBy(point: location) else {
            return
        }
        
        if !GameManager.instance().canPicker(from: tmp.columnIndex, index: tmp.cardIndex) {
            return
        }
        
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
        guard let columnIndex = columnOfPoint(point: location) else {
            resetPosition()
            return
        }
        
        guard let selected = self.selectedInfo else {
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
        var origin = CGPoint.init(x: 0, y: 0)
        if lastFrame != nil {
            origin =  CGPoint.init(x: lastFrame!.origin.x, y: lastFrame!.origin.y - 20)
        }
        
        let cards = selectedCardViews(selectedIndex: selected)
        for (index, item) in cards.enumerated() {
            let zPosition = lastCard?.layer?.zPosition ?? 0
            item.layer?.zPosition = zPosition + CGFloat(index + 1)
            item.setFrameOrigin(NSPoint.init(x: origin.x, y: origin.y - CGFloat(index) * kInnerMargin))
        }
        selectedInfo = nil
        deskCardViews[columnIndex].append(contentsOf: cards)
        deskCardViews[selected.columnIndex].removeSubrange(selected.cardIndex...)
        
        if GameManager.instance().transform(column: selected.columnIndex) {
            deskCardViews[selected.columnIndex].last!.transform()
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
        let lastFrame = lastCard?.frame
        if lastFrame != nil {
            origin =  CGPoint.init(x: lastFrame!.origin.x, y: lastFrame!.origin.y - 20)
        }
        
        let cards = selectedCardViews(selectedIndex: selected)
        for (index, item) in cards.enumerated() {
            let zPosition = lastCard?.layer?.zPosition ?? 0
            item.layer?.zPosition = zPosition + CGFloat(index + 1)
            item.setFrameOrigin(NSPoint.init(x: origin.x, y: origin.y - CGFloat(index) * kInnerMargin))
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
}
