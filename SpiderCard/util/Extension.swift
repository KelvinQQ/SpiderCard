//
//  NSView+Extension.swift
//  SpiderCard
//
//  Created by admin on 2021/7/25.
//

import Foundation
import Cocoa
import CoreGraphics
import CommonCrypto

extension NSView {
    func setFrame(frame: NSRect) {
        self.setFrameOrigin(frame.origin)
        self.setFrameSize(frame.size)
    }
}

extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
    
    func cgImage() -> CGImage? {
        guard let imageSource = CGImageSourceCreateWithData(self.tiffRepresentation! as CFData, nil)  else {
            return nil
        }
       return CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    }
}

extension NSColor {
    static func randomColor() -> NSColor {
        let red = CGFloat(arc4random() % 156 + 100) / 255.0
        let green = CGFloat(arc4random() % 50) / 255.0
        let blue = CGFloat(arc4random() % 100) / 255.0
        return NSColor.init(red: red,
                            green: green,
                            blue: blue,
                            alpha: 1.0)
    }
}


public extension String {
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()

        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()
        return hash as String
    }
}
