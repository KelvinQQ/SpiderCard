//
//  ScoreAreaView.swift
//  SpiderCard
//
//  Created by admin on 2021/7/25.
//

import Cocoa

class ScoreAreaView: NSView {
    
    var scoreLabel: NSTextField?
    var actionsLabel: NSTextField?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.yellow.cgColor
        let scoreTipLabel = NSTextField.init()
        scoreTipLabel.stringValue = "分数: "
        scoreTipLabel.textColor = NSColor.black
        scoreTipLabel.isEditable = false
        self.addSubview(scoreTipLabel)
        scoreLabel = NSTextField.init()
        scoreLabel?.stringValue = "100"
        scoreLabel?.isEditable = false
        self.addSubview(scoreLabel!)
        let firstStackView = NSStackView.init()
        firstStackView.orientation = .horizontal
        firstStackView.distribution = .fillEqually
        firstStackView.addArrangedSubview(scoreTipLabel)
        firstStackView.addArrangedSubview(scoreLabel!)
        
        let stepTipLabel = NSTextField.init()
        stepTipLabel.stringValue = "步数: "
        stepTipLabel.textColor = NSColor.black
        stepTipLabel.isEditable = false
        self.addSubview(stepTipLabel)
        actionsLabel = NSTextField.init()
        actionsLabel?.stringValue = "100"
        actionsLabel?.isEditable = false
        self.addSubview(actionsLabel!)
        let secondStackView = NSStackView.init()
        secondStackView.orientation = .horizontal
        secondStackView.distribution = .fillEqually
        secondStackView.addArrangedSubview(stepTipLabel)
        secondStackView.addArrangedSubview(actionsLabel!)
        
        let stackView = NSStackView.init(frame: self.bounds)
        stackView.orientation = .vertical
        stackView.distribution = .gravityAreas
        stackView.addArrangedSubview(firstStackView)
        stackView.addArrangedSubview(secondStackView)
        self.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
