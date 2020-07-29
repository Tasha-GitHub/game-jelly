//
//  Hero.swift
//  Game Jame Game
//
//  Created by Tasha Casagni on 7/23/20.
//  Copyright © 2020 Tasha Daly. All rights reserved.
//

import SpriteKit

enum HeroType: String {
    case sword, shield, archer, theif
}

class Hero: SKSpriteNode {
    let heroType: HeroType
    
    var heroSpeed = 100
    var grabbed  = false
    var flying = false {
        didSet {
            if flying {
                physicsBody?.isDynamic = true
            }
        }
    }
    
    init(type: HeroType){
        heroType = type
        
        let skin = SKTexture(imageNamed: type.rawValue)
        super.init(texture: skin, color: UIColor.clear, size: skin.size())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func impulse(reducer: Int){
        heroSpeed -= reducer
    }
}
