//
//  SettingViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

class SettingViewController: NSViewController {
    
    var selectedDifficult = Preference.instance.difficult

    @IBAction func saveAction(_ sender: NSButton) {
        Preference.instance.difficult = selectedDifficult
        Preference.instance.save()
        self.dismiss(self)
    }

    @IBAction func cancelAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    @IBAction func changeDifficultAction(_ sender: NSButton) {
        selectedDifficult = Difficult.init(rawValue: sender.tag)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let easyButton = self.view.viewWithTag(11) as! NSButton
        easyButton.state = Preference.instance.difficult == .easy ? .on : .off
        
        let middleButton = self.view.viewWithTag(12) as! NSButton
        middleButton.state = Preference.instance.difficult == .middle ? .on : .off
        
        let hardButton = self.view.viewWithTag(13) as! NSButton
        hardButton.state = Preference.instance.difficult == .hard ? .on : .off
    }
    
}
