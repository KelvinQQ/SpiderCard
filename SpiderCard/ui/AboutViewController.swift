//
//  AboutViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa
import WebKit

class AboutViewController: NSViewController {

    @IBOutlet weak var versionLabel: NSTextField!

    @IBAction func starAction(_ sender: NSButton) {
        NSWorkspace.shared.open(URL.init(string: "https://github.com/KelvinQQ/SpiderCard")!)
        self.dismiss(self)
    }
    
    @IBAction func dismissAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.stringValue = "V\(version)"
        }
    }
    
}
