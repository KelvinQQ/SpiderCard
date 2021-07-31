//
//  MainViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

class MainViewController: NSViewController, WaitingAreaViewDelegate, DeskAreaViewDelegate {
    
    var deskAreaView: DeskAreaView?
    var waitingAreaView: WaitingAreaView?
    var scoreAreaView: ScoreAreaView?
    var finishedAreaView: FinishedAreaView?
    var winView: WinView?
    
    var actionsObservation: NSKeyValueObservation?
    var scoreObservation: NSKeyValueObservation?

    @IBAction func newGameAction(sender: NSMenuItem) {

        let alert = NSAlert.init()
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "取消")
        alert.messageText = "提示"
        alert.informativeText = "清空当前状态重来一局?"
        alert.beginSheetModal(for: self.view.window!) { (returnCode: NSApplication.ModalResponse) in
            if returnCode == .alertFirstButtonReturn {
                self.newGame()
            }
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
        
        actionsObservation = GameManager.instance().observe(\.poker.actions, options: .new, changeHandler: { (obj, value) in
            if let actions = value.newValue {
                self.scoreAreaView?.upate(actions: actions)
            }
        })
        
        scoreObservation = GameManager.instance().observe(\.poker.score, options: .new, changeHandler: { (obj, value) in
            if let score = value.newValue {
                self.scoreAreaView?.upate(score: score)
            }
        })
        
    }
    
    deinit {
        if let ob = actionsObservation {
            self.removeObserver(ob, forKeyPath: "poker.actions")
        }
        if let ob = scoreObservation {
            self.removeObserver(ob, forKeyPath: "poker.score")
        }
    }
    
    func newGame() {
        deskAreaView?.removeFromSuperview()
        waitingAreaView?.removeFromSuperview()
        scoreAreaView?.removeFromSuperview()
        finishedAreaView?.removeFromSuperview()
        
        GameManager.instance().start()
        
        var frame = self.view.bounds
        frame.size.height = frame.height * 0.7
        frame.origin.y = frame.origin.y + self.view.bounds.height - frame.height - Const.TOP_MARGIN
        deskAreaView = DeskAreaView.init(frame: frame,
                                         cards: GameManager.instance().deskAreaCards)
        deskAreaView?.delegate = self
        
        waitingAreaView = WaitingAreaView.init(cards: GameManager.instance().waittingAreaCards)
        waitingAreaView?.setFrameOrigin(CGPoint.init(x: self.view.bounds.width - waitingAreaView!.bounds.width - 20,
                                                     y: waitingAreaView!.bounds.origin.y + Const.BOTTOM_MARGIN))
        waitingAreaView?.delegate = self
        
        scoreAreaView = ScoreAreaView.init(frame: CGRect.init(x: self.view.bounds.midX - 100, y: Const.BOTTOM_MARGIN, width: 200, height: 100))
        
        finishedAreaView = FinishedAreaView.init(cards: GameManager.instance().finishedAreaCards)
        finishedAreaView?.setFrameOrigin(CGPoint.init(x: 20, y: Const.BOTTOM_MARGIN))
        
        self.view.addSubview(deskAreaView!)
        self.view.addSubview(waitingAreaView!)
        self.view.addSubview(scoreAreaView!)
        self.view.addSubview(finishedAreaView!)
    }
    
    func didDeal() {
        
        let columns = GameManager.instance().checkAllColumn()
        if columns.count > 0 {
            print(columns)
        }
        
        deskAreaView?.cards = GameManager.instance().deskAreaCards
        deskAreaView?.reloadData()
        
//        print(GameManager.instance().deskAreaCards)
//        print(GameManager.instance().waittingAreaCards)
    }
    
    func didFinish() {
        finishedAreaView?.finishedCards = GameManager.instance().finishedAreaCards
        finishedAreaView?.reloadData()
        
        if GameManager.instance().isFinished() {
            let alert = NSAlert.init()
            alert.alertStyle = .warning
            alert.addButton(withTitle: "确定")
            alert.messageText = "恭喜"
            alert.informativeText = "你赢了!!!再来一局!!"
            alert.beginSheetModal(for: self.view.window!) { (returnCode: NSApplication.ModalResponse) in
                if returnCode == .alertFirstButtonReturn {
                    self.newGame()
                }
            }
        }
    }
    
    
    
}
