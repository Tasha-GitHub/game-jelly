//
//  GameScene.swift
//  Game Jame Game
//
//  Created by Tasha Casagni on 7/20/20.
//  Copyright © 2020 Tasha Daly. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RoundState {
    case ready, flying, finished, animating
}

class GameScene: SKScene {
    var mapNode = SKTileMapNode()
    let gameCamera = GameCamera()
    var panRecognizer = UIPanGestureRecognizer()
    
    var hero = Hero(type: .sword)
    var heros = [
        Hero(type: .sword),
        Hero(type: .shield),
        Hero(type: .theif),
        Hero(type: .archer)
    ]
    let anchor = SKNode()
    
    var roundState = RoundState.ready
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self 
        setupLevel()
        setupGestureRecognizers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch roundState {
        case .ready:
            if let touch = touches.first {
                let location = touch.location(in: self)
                if hero.contains(location){
                    hero.grabbed = true
                    hero.position = location
                }
            }
        case .flying:
            break
        case .finished:
            guard let view = view else {return}
            roundState = .animating
            let moveCameraBackAction = SKAction.move(to: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), duration: 2.0)
            moveCameraBackAction.timingMode = .easeInEaseOut
            gameCamera.run(moveCameraBackAction, completion: {
                self.addHero()
                
            })
        case .animating:
            break
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if hero.grabbed {
                let location = touch.location(in: self)
                hero.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hero.grabbed {
            gameCamera.setConstrains(with: self, and: mapNode.frame, to: hero)
            hero.grabbed = false
            hero.flying = true
            roundState = .flying
            constrantToAnchor(active: false)
            let dx  = anchor.position.x - hero.position.x
            let dy = anchor.position.y - hero.position.y
            let impulse = CGVector(dx: dx, dy: dy)
            hero.physicsBody?.applyImpulse(impulse)
            hero.isUserInteractionEnabled = false
        }
    }
    
    func setupGestureRecognizers(){
    }
    
    func setupLevel(){
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
        }
        
        addCamera()
        
        for child in mapNode.children {
            if let child = child as? SKSpriteNode {
                guard let name = child.name else {continue}
                if !["slug", "slime", "void"].contains(name) {continue}
                guard let type = EnemyType(rawValue: name) else {continue}
                let enemy = Enemy(type: type)
                enemy.size = child.size
                enemy.position = child.position
                enemy.zPosition = ZPosition.obstacles
                enemy.createPhysicsBody()
                mapNode.addChild(enemy)
                child.removeFromParent()
            }
        }
        let physicsRect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height - mapNode.tileSize.height )
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsRect)
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.hero | PhysicsCategory.enemy
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
        anchor.position = CGPoint(x: mapNode.frame.midX/2, y: mapNode.frame.midY/2)
        addChild(anchor)
        addHero()
        
    }
    
    func addCamera(){
        guard let view = view else {return}
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        camera = gameCamera
        gameCamera.setConstrains(with: self, and: mapNode.frame, to: nil)
    }
    
    func addHero(){
        
        if heros.isEmpty {
            print("no more heros")
            return
        }
        
        hero = heros.removeFirst()
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.categoryBitMask = PhysicsCategory.hero
        hero.physicsBody?.contactTestBitMask = PhysicsCategory.all
        hero.physicsBody?.collisionBitMask = PhysicsCategory.edge | PhysicsCategory.enemy
        hero.physicsBody?.isDynamic = false
        hero.position = anchor.position
        addChild(hero)
        hero.aspectScale(to: mapNode.tileSize, width: false, multiplier: 1.0)
        constrantToAnchor(active: true)
        roundState = .ready
    }
    
    func constrantToAnchor(active: Bool){
        if active {
            let slingRange = SKRange(lowerLimit: 0.0, upperLimit: hero.size.width*3)
            let positionConstraint = SKConstraint.distance(slingRange, to: anchor)
            hero.constraints = [positionConstraint]
        } else {
            hero.constraints?.removeAll()
        }
    }
    
    override func didSimulatePhysics() {
        guard let physicsBody = hero.physicsBody else {return}
        if roundState == .flying && physicsBody.isResting{
            gameCamera.setConstrains(with: self, and: mapNode.frame, to: nil)
            hero.removeFromParent()
            roundState = .finished
        }
    }
}


extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
        case PhysicsCategory.hero | PhysicsCategory.enemy:
            if let enemy = contact.bodyB.node as? Enemy {
                enemy.impact(touched: true)
            } else if let enemy = contact.bodyA.node as? Enemy {
                enemy.impact(touched: true)
                
            }
        case PhysicsCategory.hero | PhysicsCategory.edge:
           hero.flying = false
           hero.impulse(reducer: 10)
        default:
            break
        }
    }
}

extension GameScene {
    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let view = view else {return}
        let translation = sender.translation(in: view)
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
}
