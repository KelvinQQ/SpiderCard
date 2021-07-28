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
        
        GameManager.instance().start()
        
        print("\(self.view.bounds)")
        var frame = self.view.bounds
        frame.size.height = frame.height * 0.7
        frame.origin.y = frame.origin.y + self.view.bounds.height - frame.height
        deskAreaView = DeskAreaView.init(frame: frame,
                                         cards: GameManager.instance().deskAreaCards)
        waitingAreaView = WaitingAreaView.init(cardScale: deskAreaView!.cardScale, cards: GameManager.instance().waittingAreaCards)
        waitingAreaView?.setFrameOrigin(CGPoint.init(x: self.view.bounds.width - waitingAreaView!.bounds.width,
                                                     y: waitingAreaView!.bounds.origin.y))
        
        let scoreAreaView = ScoreAreaView.init(frame: CGRect.init(x: self.view.bounds.midX - 100, y: 0, width: 200, height: 100))
        self.view.addSubview(deskAreaView!)
        self.view.addSubview(waitingAreaView!)
        self.view.addSubview(scoreAreaView)
    }
    
}
