//
//  AboutViewController.swift
//  SpiderCard
//
//  Created by admin on 2021/7/24.
//

import Cocoa

class AboutViewController: NSViewController {

    @IBOutlet weak var versionLabel: NSTextField!
    
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
