//
//  RunSagRunEnemy.swift
//  SagAdventures
//
//  Created by Alex Freitas on 15/09/21.
//

import SpriteKit
import GameplayKit

extension RunSagRun {
    func enemyAppearance(quantity: Int) {
        let ratio: CGFloat = 0.7
        let gameLength = Int(ground.size.width)
        let enemiesGap = gameLength / (quantity + 1)
        var enemyPositionX = CGFloat(enemiesGap)

        if quantity > 0 {
            for _ in 1...quantity {
                risall = SKSpriteNode(imageNamed: "Risall")
                risall.position = CGPoint(x: enemyPositionX, y: 160)
                risall.zPosition = CGFloat(1.0)

                risall.size = CGSize(width: risall.size.width * ratio, height: risall.size.height * ratio)
                
                risall.physicsBody?.affectedByGravity = false
                risall.physicsBody?.isDynamic = true
                risall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: risall.size.width, height: risall.size.height))
                risall.physicsBody?.restitution = 0.0
                risall.physicsBody?.categoryBitMask = enemyCategory
                risall.physicsBody?.collisionBitMask = PhysicsCategory.enemy
                risall.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // // 5
                
               
                enemyPositionX = enemyPositionX + CGFloat(enemiesGap)

                addChild(risall)
            }
        }
    }
}
