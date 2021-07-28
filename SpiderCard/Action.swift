//
//  Action.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

protocol Action {
    func `do`(poker: Poker) -> Bool
    func undo(poker: Poker) -> Bool
}

extension Action {
    func `do`(poker: Poker) -> Bool {
        return false
    }
    func undo(poker: Poker) -> Bool {
        return false
    }
}

class Picker: Action {
    var from = -1
    var index = 0
    
    init(from: Int, index: Int) {
        self.from = from
        self.index = index
    }
    
    func `do`(poker: Poker) -> Bool {
        let cards = Array.init(poker.deskArea[from][index...])
        var last = cards[0]
        if !last.mode {
            return false
        }
        for i in 1..<cards.count {
            if !cards[i].mode {
                return false
            }
            if cards[i].suit != last.suit {
                return false
            }
            if cards[i].point - last.point != -1 {
                return false
            }
            last = cards[i]
        }
        return true
    }
    
}


/// 一叠牌
class Finish: Action {
    var column = -1
    
    init(column: Int) {
        self.column = column
    }
    
    func `do`(poker: Poker) -> Bool {
        var last = poker.deskArea[column][0]
        if last.point == 0 {
            return false
        }
        if poker.deskArea[column].count < 13 {
            return false
        }
        for i in 1...12 {
            let current = poker.deskArea[column][i]
            if current.suit != last.suit {
                return false
            }
            if current.point - last.point != 1 {
                return false
            }
            last = current
        }
        let tmp = poker.deskArea[column][0...12]
        poker.finishedArea.append(Array.init(tmp))
        poker.deskArea[column].removeSubrange(0...12)
        return true
    }
    
}

/// 翻拍
class Transform: Action {
    func `do`(poker: Poker) -> Bool {
        if let last = poker.deskArea[column].last {
            last.mode = true
            return true
        }
        return false
    }
    
    var column = -1
    init(column: Int) {
        self.column = column
    }
    
}


/// 发牌
class Deal: Action {
    func `do`(poker: Poker) -> Bool {
        if !canDeal(poker: poker) {
            return false
        }
        for i in 0..<Poker.DESK_COLUMN_COUNT {
            poker.deskArea[i].append(poker.waitingArea[poker.waitingArea.count-1][i])
        }
        poker.waitingArea.removeLast()
        return true
    }
    
    func canDeal(poker: Poker) -> Bool {
        if poker.waitingArea.count < 12 {
            return false
        }
        for i in 0..<Poker.DESK_COLUMN_COUNT {
            let columns = poker.deskArea[i]
            if columns.count == 0 {
                return false
            }
            if columns[0].mode == false {
                return false
            }
        }
        return true
    }
}

/// 移动
class Move: Action {
    var from = -1
    var to = -1
    var index = -1
    
    func `do`(poker: Poker) -> Bool {

        if !canMoveTo(poker: poker) {
            return false
        }
        move(poker: poker)
        return true
    }
    
    func move(poker: Poker) {
        poker.deskArea[to].append(contentsOf: poker.deskArea[from][index...])
        poker.deskArea[from].removeSubrange(index...)
    }
    
    func canMove(poker: Poker) -> Bool {
        let cards = poker.deskArea[from]
        var last = cards[0]
        for i in index..<cards.count {
            if cards[i].suit != last.suit {
                return false
            }
            if cards[i].point - last.point != 1 {
                return false
            }
            last = cards[i]
        }
        return true
    }
    
    func canMoveTo(poker: Poker) -> Bool {
        if poker.deskArea[to].isEmpty {
            return true
        }
        if poker.deskArea[to].last!.point != poker.deskArea[from][index].point + 1 {
            return false
        }
        return true
    }
    
    init(from: Int, to: Int, index: Int) {
        self.from = from
        self.to = to
        self.index = index
    }
}

class Wash: Action {
    func `do`(poker: Poker) -> Bool {
        // 4 * 13 * 2 = 104 张牌
        var all = Array<Card>()

        for i in 0...3 {
            for j in 1...13 {
                let card = Card(suit: Suit.init(rawValue: i), point: j, mode: true)
                all.append(card)
                all.append(card.copy())
            }
        }
        // 打乱
        all.shuffle()
        // 刚开始分配54张牌 = 4 * 6 + 6 * 5
        for i in 0...3 {
            for j in 0...5 {
                let card = all[j + i * 6]
                if j < 5 {
                    card.mode = false
                }
                poker.deskArea[i].append(card)
            }
        }
        all.removeSubrange(...23)
        for i in 4...9 {
            for j in 0...4 {
                let card = all[j + (i-4) * 5]
                if j < 4 {
                    card.mode = false
                }
                poker.deskArea[i].append(card)
            }
        }
        all.removeSubrange(...29)
        // 开始分配剩余50张牌
        for i in 0...4 {
            for j in 0...9 {
                let card = all[j + i * 10]
                card.mode = false
                poker.waitingArea[i].append(card)
            }
        }
        return true
    }
}

class Reset: Action {
    func `do`(poker: Poker) -> Bool {
        poker.deskArea.removeAll()
        poker.finishedArea.removeAll()
        poker.waitingArea.removeAll()
        
        poker.waitingArea = [[],[],[],[],[],]
        poker.finishedArea = [[],[],[],[],
                              [],[],[],[],]
        poker.deskArea = [[],[],[],[],[],
                          [],[],[],[],[],]
        return true
    }
}

