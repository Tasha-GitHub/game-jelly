//
//  SKNode+Extensions.swift
//  Game Jame Game
//
//  Created by Tasha Casagni on 7/27/20.
//  Copyright © 2020 Tasha Daly. All rights reserved.
//

import SpriteKit

extension SKNode{
    func aspectScale(to size: CGSize, width: Bool, multiplier: CGFloat){
        let scale = width ?  (size.width * multiplier)/self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        
        self.setScale(scale)
    }
}
