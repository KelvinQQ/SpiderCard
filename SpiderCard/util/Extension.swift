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
    
    func resize(size: CGSize) -> NSImage {
        let targetFrame = NSRect.init(origin: CGPoint.zero, size: size)
        let targetImage = NSImage.init(size: size)
        
        let sourceSize = self.size
        let radioH = size.height / sourceSize.height
        let radioW = size.width / sourceSize.width
        
        var cropRect = NSRect.zero
        if radioH > radioW {
            cropRect.size.width = floor(size.width / radioH)
            cropRect.size.height = sourceSize.height
        } else {
            cropRect.size.width = sourceSize.width
            cropRect.size.height = floor(size.height / radioW)
        }
        
        targetImage.lockFocus()
        self.draw(in: targetFrame,
                  from: cropRect,
                  operation: .copy,
                  fraction: 1.0,
                  respectFlipped: true,
                  hints: [.interpolation: NSImageInterpolation.high.rawValue])
        targetImage.unlockFocus()
        return targetImage
    }
    
//    func blur(radius: CGFloat = 1.0) -> NSImage? {
//        let filter = CIFilter(name: "CIGaussianBlur")!
//        filter.setValue(self, forKey:kCIInputImageKey)
//        filter.setValue(radius, forKey: kCIInputRadiusKey)
//        let outputCIImage = filter.outputImage!
//        let rect = CGRect(origin: CGPoint.zero, size: self.size)
//        guard let cgImage = CIContext(options: nil).createCGImage(outputCIImage, from: rect) else {
//            return nil
//        }
//        return NSImage.init(cgImage: cgImage, size: self.size)
//    }
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
