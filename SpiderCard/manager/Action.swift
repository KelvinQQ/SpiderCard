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
        guard var last = poker.deskArea[column].last else {
            return false
        }
        
        if last.point != 1 {
            return false
        }
        let count = poker.deskArea[column].count
        
        if count < 13 {
            return false
        }
        let start = count - 13
        for current in poker.deskArea[column][start...count-2].reversed() {
            if current.suit != last.suit {
                return false
            }
            if current.point - last.point != 1 {
                return false
            }
            last = current
        }
        let tmp = poker.deskArea[column][start...count-1]
        poker.finishedArea.append(Array.init(tmp))
        poker.deskArea[column].removeSubrange(start...count-1)
        return true
    }
    
    func undo(poker: Poker) -> Bool {
        guard let cards = poker.finishedArea.last else {
            return false
        }
        poker.deskArea[column].append(contentsOf: cards)
        poker.finishedArea.removeLast()
        return true
    }
    
}

/// 翻拍
class Transform: Action {
    func `do`(poker: Poker) -> Bool {
        if let last = poker.deskArea[column].last, last.mode == false {
            last.mode = true
            return true
        }
        return false
    }
    
    var column = -1
    init(column: Int) {
        self.column = column
    }
    
    func undo(poker: Poker) -> Bool {
        if let last = poker.deskArea[column].last {
            last.mode = false
            return true
        }
        return false
    }
}


/// 发牌
class Deal: Action {
    func `do`(poker: Poker) -> Bool {
        if !canDeal(poker: poker) {
            return false
        }
        for i in 0..<Const.DESK_COLUMN_COUNT {
            let card = poker.waitingArea[poker.waitingArea.count-1][i]
            card.mode =  true
            poker.deskArea[i].append(card)
        }
        poker.waitingArea.removeLast()
        return true
    }
    
    func undo(poker: Poker) -> Bool {
        var cards: Array<Card> = []
        for i in 0..<Const.DESK_COLUMN_COUNT {
            let card = poker.deskArea[i].last!
            card.mode = false
            cards.append(card)
            poker.deskArea[i].removeLast()
        }
//        if cards.count != Const.DESK_COLUMN_COUNT {
//            return false
//        }
        poker.waitingArea.append(cards)
        return true
    }
    
    func canDeal(poker: Poker) -> Bool {
        guard let cards = poker.waitingArea.last, cards.count == 10 else {
            return false
        }
        let total = poker.deskArea
            .map { (cards) -> Int in
                return cards.count
            }
            .reduce(0, +)
        
        for i in 0..<Const.DESK_COLUMN_COUNT {
            let columns = poker.deskArea[i]
            if columns.count == 0 && total >= 10 {
                return false
            }
            if columns.last == nil || columns.last!.mode == false {
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
    var count = -1
    
    func `do`(poker: Poker) -> Bool {

        if !canMoveTo(poker: poker) {
            return false
        }
        move(poker: poker)
        return true
    }
    
    func undo(poker: Poker) -> Bool {
        let size = poker.deskArea[to].count - count
        poker.deskArea[from].append(contentsOf: poker.deskArea[to][size...])
        poker.deskArea[to].removeSubrange(size...)
        return true
    }
    
    func move(poker: Poker) {
        let size = poker.deskArea[from].count - count
        poker.deskArea[to].append(contentsOf: poker.deskArea[from][size...])
        poker.deskArea[from].removeSubrange(size...)
    }
    
    func canMove(poker: Poker) -> Bool {
        let cards = poker.deskArea[from]
        var last = cards[0]
        for i in (poker.deskArea[from].count - count)..<cards.count {
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
        if poker.deskArea[to].last!.point != poker.deskArea[from][poker.deskArea[from].count - count].point + 1 {
            return false
        }
        return true
    }
    
    init(from: Int, to: Int, count: Int) {
        self.from = from
        self.to = to
        self.count = count
    }
}

class Wash: Action {
    var difficult = Difficult.easy
    init(difficult: Difficult) {
        self.difficult = difficult
    }
    
    func `do`(poker: Poker) -> Bool {
        // 4 * 13 * 2 = 104 张牌
        var all = Array<Card>()

        for i in 1...13 {
            switch difficult {
            case .easy:
                for _ in 0...7 {
                    let card = Card(suit: Suit.init(rawValue: 0), point: i, mode: false)
                    all.append(card)
                }
            case .middle:
                for j in 0...1 {
                    let card = Card(suit: Suit.init(rawValue: j), point: i, mode: false)
                    all.append(card)
                    all.append(card.copy())
                    all.append(card.copy())
                    all.append(card.copy())
                }
            case .hard:
                for j in 0...3 {
                    let card = Card(suit: Suit.init(rawValue: j), point: i, mode: false)
                    all.append(card)
                    all.append(card.copy())
                }
            }
            
        }

        // 打乱
        all.shuffle()
        // 刚开始分配54张牌 = 4 * 6 + 6 * 5
        for i in 0...53 {
            let column = i % 10
            let card = all[i]
            if column >= 4 && poker.deskArea[column].count >= 4 {
                card.mode = true
            }
            if column <= 3 && poker.deskArea[column].count >= 5 {
                card.mode = true
            }
            poker.deskArea[column].append(card)
        }
        
        all.removeSubrange(...53)
        
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
        poker.finishedArea = []
        poker.deskArea = [[],[],[],[],[],
                          [],[],[],[],[],]
        poker.score = 500
        poker.actions = 0
        return true
    }
}

