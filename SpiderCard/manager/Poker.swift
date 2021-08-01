//
//  Poker.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

class Poker: NSObject {
    
    @objc dynamic var score = 500
    @objc dynamic var actions = 0
    
    var waitingArea: Array<Array<Card>> = [[],[],[],[],[],]
    var finishedArea: Array<Array<Card>> = [[],[],[],[],
                                            [],[],[],[],]
    var deskArea: Array<Array<Card>> = [[],[],[],[],[],
                                        [],[],[],[],[],]
}

