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
    
    func setupLabel(label: NSTextField?, text: String) {
        label?.isBordered = false
        label?.backgroundColor = NSColor.clear
        label?.stringValue = text
        label?.textColor = NSColor.black
        label?.isEditable = false
        label?.font = NSFont.systemFont(ofSize: 15)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        
        let scoreTipLabel = NSTextField.init()
        setupLabel(label: scoreTipLabel, text:"分数: ")
        self.addSubview(scoreTipLabel)
        scoreLabel = NSTextField.init()
        setupLabel(label: scoreLabel, text:"100")
        self.addSubview(scoreLabel!)
        
        let firstStackView = NSStackView.init()
        firstStackView.orientation = .horizontal
        firstStackView.distribution = .fillEqually
        firstStackView.addArrangedSubview(scoreTipLabel)
        firstStackView.addArrangedSubview(scoreLabel!)
        
        let stepTipLabel = NSTextField.init()
        setupLabel(label: stepTipLabel, text:"步数: ")
        self.addSubview(stepTipLabel)
        actionsLabel = NSTextField.init()
        setupLabel(label: actionsLabel, text:"100")
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
