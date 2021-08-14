//
//  Manager.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

class GameManager: NSObject {
    var searchIndex: TipInfo = .invalidTip()
    
    var actions: Array<Action> = []
    @objc dynamic var poker: Poker = Poker()
    
    static let instance: GameManager = GameManager()
    
    var deskAreaCards: Array<Array<Card>> {
        return poker.deskArea
    }
    
    var waittingAreaCards: Array<Array<Card>> {
        return poker.waitingArea
    }
    
    var finishedAreaCards: Array<Array<Card>> {
        return poker.finishedArea
    }
    
    private override init() {
        
    }
    
    
    func start() {
        let reset = Reset()
        if reset.do(poker: poker) {
//            actions.append(reset)
        }
        let wash = Wash.init(difficult: Preference.instance.difficult)
        if wash.do(poker: poker) {
//            actions.append(wash)
        }
    }
    
    func stop() {
        
    }
    
    func canPicker(from: Int, index: Int) -> Bool {
        let picker = Picker(from: from, index: index)
        return picker.do(poker: poker)
    }
    
    func move(from: Int, to: Int, index: Int) -> Bool {
        let count = poker.deskArea[from].count - index
        let move = Move(from: from, to: to, count: count)
        if move.do(poker: poker) {
            actions.append(move)
            poker.score -= 1
            poker.actions += 1
            return true
        }
        return false
    }
    
    func transform(column: Int) -> Bool {
        let transform = Transform(column: column)
        if transform.do(poker: poker) {
            actions.append(transform)
            return true
        }
        return false
    }
    
    func finish(column: Int) -> Bool {
        let finish = Finish(column: column)
        if finish.do(poker: poker) {
            actions.append(finish)
            poker.score += 100
            return true
        }
        return false
    }
    
    func deal() -> Bool {
        let deal = Deal()
        if deal.do(poker: poker) {
            actions.append(deal)
            return true
        }
        return false
    }
    
    func checkAllColumn() -> Array<Int> {
        var finishedColumn : Array<Int> = []
        for i in 0..<Const.DESK_COLUMN_COUNT {
            let finish = Finish(column: i)
            if finish.do(poker: poker) {
                actions.append(finish)
                finishedColumn.append(i)
            }
        }
        return finishedColumn
    }
    
    func isFinished() -> Bool {
        return poker.finishedArea.count == 8
    }
    
    func canUndo() -> Bool {
        return !actions.isEmpty
    }
    
    func undo() -> Bool {
        if !canUndo() {
            return false
        }
        
        var shouldBreak = false
        
        while actions.count > 0 && !shouldBreak {
            let action = actions.last!
            shouldBreak = action is Move || action is Deal
            if action.undo(poker: poker) {
                switch action {
                case is Finish:
                    poker.score -= 100
                case is Move:
                    poker.score -= 1
                    poker.actions += 1
                default:
                    break
                }
                actions.removeLast()
            } else {
                return false
            }
        }
        
        return true
        
    }
    
    func nextTip() -> TipInfo? {
//        if searchIndex.isInvaild() {
//            searchIndex = TipInfo.init(from: 0, to: 1, count: poker.deskArea[0].count - 1)
//        }
//        for index in (0...searchIndex.count).reversed() {
//            let count = poker.deskArea[searchIndex.column].count - index
//            for column in 0..<poker.deskArea.count {
//                if column == searchIndex.column {
//                    continue
//                }
//                let tip = Tip.init(from: searchIndex.column, to: column, count: count)
//                if tip.do(poker: poker) {
//                    searchIndex.index = index
//                    return TipInfo.init(from: searchIndex.column, to: column, count: count)
//                }
//            }
//            searchIndex = SearchTipIndex.init(column: searchIndex.column + 1, index: poker.deskArea[searchIndex.column].count - 1)
//            if searchIndex.column >= Const.DESK_COLUMN_COUNT {
//                searchIndex = .invaildIndex()
//                return nil
//            }
//        }
        return nil
    }
}
