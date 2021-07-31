//
//  Poker.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

class Poker: NSObject {
    
    static let DESK_COLUMN_COUNT = 10
    static let DESK_HEAD_COUNT = 6
    static let DES_TAIL_COUNT = 5
    
    @objc dynamic var score = 500
    @objc dynamic var actions = 0
    
    var waitingArea: Array<Array<Card>> = [[],[],[],[],[],]
    var finishedArea: Array<Array<Card>> = [[],[],[],[],
                                            [],[],[],[],]
    var deskArea: Array<Array<Card>> = [[],[],[],[],[],
                                        [],[],[],[],[],]
}

