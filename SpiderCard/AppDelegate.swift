//
//  AppDelegate.swift
//  SpiderCard
//
//  Created by admin on 2021/7/16.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApp.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(closeWindow),
                                               name: NSWindow.willCloseNotification,
                                               object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func closeWindow() {
        NSApp.terminate(self)
    }


}

