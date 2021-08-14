//
//  CardTip.swift
//  SpiderCard
//
//  Created by admin on 2021/8/6.
//

import Cocoa

struct TipInfo: CustomStringConvertible {
    var description: String {
        return "from = \(from) to = \(to) count = \(count)"
    }
    
    var from: Int
    var to: Int
    var count: Int
    
    static func invalidTip() -> TipInfo {
        return TipInfo.init(from: -1, to: -1, count: -1)
    }
    
    func isInvaild() -> Bool {
        return self.from < 0 || self.to < 0 || self.count < 0
    }
}
