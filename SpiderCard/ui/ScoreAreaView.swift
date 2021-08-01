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
        label?.textColor = NSColor.white.withAlphaComponent(0.8)
        label?.isEditable = false
        label?.font = NSFont.systemFont(ofSize: 15)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.init(red: 15.0/255.0, green: 126.0/255.0, blue: 18.0/255.0, alpha: 1.0).cgColor
        self.layer?.borderColor = NSColor.black.cgColor
        self.layer?.borderWidth = 1.0
        
        let scoreTipLabel = NSTextField.init()
        setupLabel(label: scoreTipLabel, text:"分数: ")
        self.addSubview(scoreTipLabel)
        scoreLabel = NSTextField.init()
        setupLabel(label: scoreLabel, text:"500")
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
        setupLabel(label: actionsLabel, text:"0")
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
    
    func upate(score: Int) {
        scoreLabel?.stringValue = "\(score)"
    }
    func upate(actions: Int) {
        actionsLabel?.stringValue = "\(actions)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
