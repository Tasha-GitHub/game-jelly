 //
//  Configuration.swift
//  Game Jame Game
//
//  Created by Tasha Casagni on 7/21/20.
//  Copyright © 2020 Tasha Daly. All rights reserved.
//

import CoreGraphics
 
 struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let edge: UInt32 = 0x1
    static let hero: UInt32 = 0x1 << 1
    static let enemy: UInt32 = 0x1 << 2 
 }
 
 struct ZPosition {
    static let background: CGFloat = 0
    static let obstacles: CGFloat = 1
 }
 
 extension CGPoint{
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right , y: left.y * right)
    }
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    static public func +  (left: CGPoint, right: CGPoint) -> CGPoint{
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
 }
