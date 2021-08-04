//
//  MainViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

struct RefreshArea: OptionSet {
    
    var rawValue: UInt

    static let waitting          = RefreshArea(rawValue: 1 << 0)
    static let desk              = RefreshArea(rawValue: 1 << 1)
    static let finished          = RefreshArea(rawValue: 1 << 2)
    static let all: RefreshArea  = [.waitting, .desk, .finished]
}

class MainViewController: NSViewController, WaitingAreaViewDelegate, DeskAreaViewDelegate {
    
    @IBOutlet weak var backgroundImageView: NSImageView!
    @IBOutlet weak var undoMenuItem: NSMenuItem!
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
    
    @IBAction func undoAction(sender: NSMenuItem) {
        if GameManager.instance.undo() {
            refreshViews(area: .all)
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
        
        actionsObservation = GameManager.instance.observe(\.poker.actions, options: .new, changeHandler: { (obj, value) in
            if let actions = value.newValue {
                self.scoreAreaView?.upate(actions: actions)
            }
        })
        
        scoreObservation = GameManager.instance.observe(\.poker.score, options: .new, changeHandler: { (obj, value) in
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
        
        GameManager.instance.start()
        AudioPlayer.instance().play(type: .launch)
        
        deskAreaView = DeskAreaView.init(frame: self.view.bounds,
                                         cards: GameManager.instance.deskAreaCards)
        deskAreaView?.delegate = self
        
        waitingAreaView = WaitingAreaView.init(cards: GameManager.instance.waittingAreaCards)
        waitingAreaView?.setFrameOrigin(CGPoint.init(x: self.view.bounds.width - waitingAreaView!.bounds.width - Const.RIGHT_MARGIN,
                                                     y: waitingAreaView!.bounds.origin.y + Const.BOTTOM_MARGIN))
        waitingAreaView?.delegate = self
        
        scoreAreaView = ScoreAreaView.init(frame: CGRect.init(x: self.view.bounds.midX - Const.SCORE_AREA_VIEW_WIDTH / 2.0, y: Const.BOTTOM_MARGIN, width: Const.SCORE_AREA_VIEW_WIDTH, height: Const.SCORE_AREA_VIEW_HEIGHT))
        
        finishedAreaView = FinishedAreaView.init(cards: GameManager.instance.finishedAreaCards)
        finishedAreaView?.setFrameOrigin(CGPoint.init(x: Const.LEFT_MARGIN, y: Const.BOTTOM_MARGIN))
        scoreAreaView?.startTimer()
        self.view.addSubview(waitingAreaView!)
        self.view.addSubview(scoreAreaView!)
        self.view.addSubview(finishedAreaView!)
        self.view.addSubview(deskAreaView!)
        deskAreaView?.setWaitingAreaRect(rect: waitingAreaView!.frame)
    }
    
    func didDeal() {
        
        let columns = GameManager.instance.checkAllColumn()
        if columns.count > 0 {
            print(columns)
        }
        
        refreshViews(area: [.desk, .finished])
    }
    
    func refreshViews(area: RefreshArea) {
        if area.contains(.desk) {
            deskAreaView?.cards = GameManager.instance.deskAreaCards
            deskAreaView?.reloadData()
        }
        if area.contains(.finished) {
            finishedAreaView?.cards = GameManager.instance.finishedAreaCards
            finishedAreaView?.reloadData()
        }
        if area.contains(.waitting) {
            waitingAreaView?.cards = GameManager.instance.waittingAreaCards
            waitingAreaView?.reloadData()
        }
    }
    
    func didFinish() {
        
        refreshViews(area: .finished)
        
        if GameManager.instance.isFinished() {
            AudioPlayer.instance().play(type: .success)
            scoreAreaView?.stopTimer()
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
