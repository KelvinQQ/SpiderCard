//
//  NSView+Extension.swift
//  SpiderCard
//
//  Created by admin on 2021/7/25.
//

import Foundation
import Cocoa

extension NSView {
    func setFrame(frame: NSRect) {
        self.setFrameOrigin(frame.origin)
        self.setFrameSize(frame.size)
    }
}
