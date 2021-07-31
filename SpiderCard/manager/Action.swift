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
            let card = poker.waitingArea[poker.waitingArea.count-1][i]
            card.mode =  true
            poker.deskArea[i].append(card)
        }
        poker.waitingArea.removeLast()
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
        
        for i in 0..<Poker.DESK_COLUMN_COUNT {
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
                    let card = Card(suit: Suit.init(rawValue: 0), point: i, mode: true)
                    all.append(card)
                }
            case .middle:
                for j in 0...1 {
                    let card = Card(suit: Suit.init(rawValue: j), point: i, mode: true)
                    all.append(card)
                    all.append(card.copy())
                    all.append(card.copy())
                    all.append(card.copy())
                }
            case .hard:
                for j in 0...3 {
                    let card = Card(suit: Suit.init(rawValue: j), point: i, mode: true)
                    all.append(card)
                    all.append(card.copy())
                }
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
        poker.finishedArea = []
        poker.deskArea = [[],[],[],[],[],
                          [],[],[],[],[],]
        poker.score = 500
        poker.actions = 0
        return true
    }
}

