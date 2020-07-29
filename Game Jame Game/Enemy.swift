//
//  Enemy.swift
//  Game Jame Game
//
//  Created by Tasha Casagni on 7/26/20.
//  Copyright © 2020 Tasha Daly. All rights reserved.
//

import SpriteKit

enum EnemyType: String {
    case slug, slime, void
}

class Enemy: SKSpriteNode {

    let type: EnemyType
    var bounce: Int
    var touched: Bool
    
    init(type: EnemyType) {
        self.type = type
        switch type {
        case .slug:
            bounce = 5
            touched = false
        case .slime:
             bounce = 20
            touched = false
        case .void:
             bounce = 10
            touched = false
            
        }
        let skin = SKTexture(imageNamed: type.rawValue)
        super.init(texture: skin, color: UIColor.clear, size: CGSize.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(){
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.contactTestBitMask = PhysicsCategory.all
        physicsBody?.collisionBitMask = PhysicsCategory.all
    }
    
    func impact(touched: Bool){
        if touched {
            removeFromParent()
        }
        
    }
    
}
