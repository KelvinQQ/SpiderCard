//
//  Manager.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

class GameManager {
    var actions: Array<Action> = []
    var poker: Poker = Poker()
    
    private static var singleton: GameManager?
    
    var deskAreaCards: Array<Array<Card>> {
        return poker.deskArea
    }
    
    var waittingAreaCards: Array<Array<Card>> {
        return poker.waitingArea
    }
    
    var finishedAreaCards: Array<Array<Card>> {
        return poker.finishedArea
    }
    
    static func instance() -> GameManager {
        if singleton == nil {
            singleton = GameManager()
        }
        return singleton!
    }
    private init() {
        
    }
    
    
    func start() {
        let reset = Reset()
        if reset.do(poker: poker) {
            actions.append(reset)
        }
        let wash = Wash()
        if wash.do(poker: poker) {
            actions.append(wash)
        }
        print("\(poker.deskArea)")
    }
    
    func stop() {
        
    }
    
    func canPicker(from: Int, index: Int) -> Bool {
        let picker = Picker(from: from, index: index)
        return picker.do(poker: poker)
    }
    
    func move(from: Int, to: Int, index: Int) -> Bool {
        let move = Move(from: from, to: to, index: index)
        if move.do(poker: poker) {
            actions.append(move)
            let finish = Finish(column: to)
            if finish.do(poker: poker) {
                actions.append(finish)
            }
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
            return true
        }
        return false
    }
    
    func deal() -> Bool {
        let deal = Deal()
        if deal.do(poker: poker) {
            actions.append(deal)
            
            for i in 0..<Poker.DESK_COLUMN_COUNT {
                let finish = Finish(column: i)
                if finish.do(poker: poker) {
                    actions.append(finish)
                }
                let transform = Transform(column: i)
                if transform.do(poker: poker) {
                    actions.append(transform)
                }
            }
            return true
        }
        return false
    }
}
