//
//  SettingViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

class SettingViewController: NSViewController {
    
    @IBOutlet weak var backgroundPopupButton: NSPopUpButton!
    @IBOutlet weak var popupMenu: NSMenu!
    var selectedDifficult = Preference.instance.difficult
    var selectedSoundTip = Preference.instance.soundTip
    var selectedBackground = Preference.instance.background

    @IBAction func saveAction(_ sender: NSButton) {
        Preference.instance.difficult = selectedDifficult
        Preference.instance.soundTip = selectedSoundTip
        Preference.instance.save()
        self.dismiss(self)
    }
    @IBAction func soundAction(_ sender: NSButton) {
        let tip = SoundTip.init(rawValue: UInt(sender.tag))
        if sender.state == .on {
            selectedSoundTip.insert(tip)
        } else {
            selectedSoundTip.remove(tip)
        }
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    @IBAction func changeDifficultAction(_ sender: NSButton) {
        selectedDifficult = Difficult.init(rawValue: sender.tag)
    }
    
    @IBAction func changeBackground(_ sender: NSMenuItem) {
        switch sender.tag {
        case 10:
            selectedBackground = "background"
        case 11:
            selectedBackground = "bg_1"
        case 12:
            selectedBackground = "bg_2"
        default:
            selectedBackground = "background"
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("ChangeBackground"), object: nil, userInfo: ["backgroundName": selectedBackground])
        Preference.instance.background = selectedBackground
        Preference.instance.save()
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
        
        let startButton = self.view.viewWithTag(1) as! NSButton
        startButton.state = Preference.instance.soundTip.contains(SoundTip.start) ? .on : .off
        
        let progressButton = self.view.viewWithTag(2) as! NSButton
        progressButton.state = Preference.instance.soundTip.contains(SoundTip.progress) ? .on : .off
        
        let successButton = self.view.viewWithTag(4) as! NSButton
        successButton.state = Preference.instance.soundTip.contains(SoundTip.success) ? .on : .off
        
        let tags = ["background": 10,
                    "bg_1": 11,
                    "bg_2": 12]
        let savedBg = Preference.instance.background
        let selectedTag = tags[savedBg]!
        backgroundPopupButton.selectItem(at: selectedTag - 10)
        popupMenu.items.forEach { (item) in
            if selectedTag == item.tag {
                item.state = .on
            } else {
                item.state = .off
            }
        }
    }
    
}
