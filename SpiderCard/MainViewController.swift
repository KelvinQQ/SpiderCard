//
//  MainViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

class MainViewController: NSViewController {
    
    var deskAreaView: DeskAreaView?
    var waitingAreaView: WaitingAreaView?
    var scoreAreaView: ScoreAreaView?

    @IBAction func newGameAction(sender: NSMenuItem) {

        let alert = NSAlert.init()
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "取消")
        alert.messageText = "提示"
        alert.informativeText = "清空当前状态重来一局?"
        let res = alert.runModal()
        if res == .alertFirstButtonReturn {
            newGame()
        }
    }
    
    @IBAction func aboutAction(sender: NSMenuItem) {
        let aboutVc = NSStoryboard.init(name: "About", bundle: nil).instantiateController(withIdentifier: "AboutViewController") as! AboutViewController
        self.presentAsSheet(aboutVc)
    }
    
    @IBAction func settingAction(sender: NSMenuItem) {
        let settingVc = NSStoryboard.init(name: "Setting", bundle: nil).instantiateController(withIdentifier: "SettingViewController") as! SettingViewController
        self.presentAsSheet(settingVc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        newGame()
        
    }
    
    func newGame() {
        deskAreaView?.removeFromSuperview()
        waitingAreaView?.removeFromSuperview()
        scoreAreaView?.removeFromSuperview()
        
        GameManager.instance().start()
        
        var frame = self.view.bounds
        frame.size.height = frame.height * 0.7
        frame.origin.y = frame.origin.y + self.view.bounds.height - frame.height
        deskAreaView = DeskAreaView.init(frame: frame,
                                         cards: GameManager.instance().deskAreaCards)
        waitingAreaView = WaitingAreaView.init(cardScale: deskAreaView!.cardScale, cards: GameManager.instance().waittingAreaCards)
        waitingAreaView?.setFrameOrigin(CGPoint.init(x: self.view.bounds.width - waitingAreaView!.bounds.width,
                                                     y: waitingAreaView!.bounds.origin.y))
        
//        scoreAreaView = ScoreAreaView.create
        scoreAreaView = ScoreAreaView.init(frame: CGRect.init(x: self.view.bounds.midX - 100, y: 0, width: 200, height: 100))
        self.view.addSubview(deskAreaView!)
        self.view.addSubview(waitingAreaView!)
        self.view.addSubview(scoreAreaView!)
    }
    
}
