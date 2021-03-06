//
//  Const.swift
//  SpiderCard
//
//  Created by admin on 2021/7/31.
//

import Foundation

class Const {
    static let CARD_WIDTH: CGFloat = 71.0
    static let CARD_HEIGHT: CGFloat = 96.0
    
    static let LEFT_MARGIN: CGFloat = 20.0
    static let RIGHT_MARGIN: CGFloat = 20.0
    static let TOP_MARGIN: CGFloat = 20.0
    static let BOTTOM_MARGIN: CGFloat = 20.0
    
    static let SCORE_AREA_VIEW_WIDTH: CGFloat = 200.0
    static let SCORE_AREA_VIEW_HEIGHT: CGFloat = 100.0
    
    static let VERTICAL_CARD_INNER_MARGIN_BIG: CGFloat = 25.0
    static let VERTICAL_CARD_INNER_MARGIN_SMALL: CGFloat = 15.0
    static let HORIZONTAL_CARD_INNER_MARGIN_SMALL: CGFloat = 15.0
    
    static let DESK_COLUMN_COUNT = 10
    static let DESK_HEAD_COUNT = 6
    static let DES_TAIL_COUNT = 5
    
    // 等待区
    static let WAITING_AREA_VIEW_WIDTH: CGFloat = Const.CARD_WIDTH + CGFloat(4) * Const.HORIZONTAL_CARD_INNER_MARGIN_SMALL
    static let WAITING_AREA_VIEW_HEIGHT: CGFloat = Const.CARD_HEIGHT
    
    // 结束区
    static let FINISHED_AREA_VIEW_WIDTH: CGFloat = Const.CARD_WIDTH + CGFloat(7) * Const.HORIZONTAL_CARD_INNER_MARGIN_SMALL
    static let FINISHED_AREA_VIEW_HEIGHT: CGFloat = Const.CARD_HEIGHT
}
