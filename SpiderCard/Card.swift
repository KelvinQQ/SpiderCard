//
//  Card.swift
//  Tetris
//
//  Created by admin on 2021/7/19.
//

import Cocoa

enum Suit: Int {
    // 梅花
    case clubs = 0
    // 方块
    case diamonds
    // 红桃
    case hearts
    // 黑桃
    case spades

    init(rawValue: Int) {
        let number = abs(rawValue) % 4
        switch number {
        case 0:
            self = .clubs
        case 1:
            self = .diamonds
        case 2:
            self = .hearts
        case 3:
            self = .spades
        default:
            self = .clubs
        }
    }
}


class Card: CustomStringConvertible {
    
    var description: String {
        return "suit = \(suit) point = \(point) mode = \(mode)"
    }
    
    var suit = Suit.hearts
    var point = 0
    var mode = false
    init(suit: Suit, point: Int, mode: Bool) {
        self.suit = suit
        self.point = point
        self.mode = mode
    }
    
    convenience init(suit: Suit, point: Int) {
        self.init(suit: suit, point: point, mode: false)
    }
    
    func copy() -> Card {
        return Card(suit: self.suit, point: self.point, mode: self.mode)
    }
}
