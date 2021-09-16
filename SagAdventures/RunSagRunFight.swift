//
//  RunSagRunEnemy.swift
//  SagAdventures
//
//  Created by Alex Freitas on 15/09/21.
//

import SpriteKit
import GameplayKit

extension RunSagRun {
    func createProjectile() {
        projectile = SKSpriteNode(imageNamed: "Orange")
        projectile.size = CGSize(width: projectile.size.width * 0.5, height: projectile.size.height * 0.5)
        projectile.position = CGPoint(x: sag.position.x + 36, y: sag.position.y - 6)
        projectile.zPosition = CGFloat(1.5)
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width * 0.6)

        projectile.physicsBody?.categoryBitMask = orangeCategory
        projectile.physicsBody?.collisionBitMask = enemyCategory
        projectile.physicsBody?.contactTestBitMask = enemyCategory
    }

    func throwProjectileTouch(touchLocation: CGPoint) {
        createProjectile()

        let offset = touchLocation - projectile.position
        if offset.x < 0 { return }
        addChild(projectile)

        let direction = offset.normalized()
        let shootAmount = direction * 1000

        let realDest = shootAmount + projectile.position

        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }

    func enemyAppearance() {
        let ratio: CGFloat = 0.7
        let enemyPositionX = CGFloat(11400)

        enemy = SKSpriteNode(imageNamed: "Risall")
        enemy.position = CGPoint(x: enemyPositionX, y: 160)
        enemy.zPosition = CGFloat(1.0)

        enemy.size = CGSize(width: enemy.size.width * ratio, height: enemy.size.height * ratio)

        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemy.size.width, height: enemy.size.height))
        enemy.physicsBody?.restitution = 0.0
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.collisionBitMask = sagCategory
        enemy.physicsBody?.contactTestBitMask = sagCategory

        let textureAtlas = SKTextureAtlas(named: "RisallRunning")
        for index in 0..<textureAtlas.textureNames.count {
            let textureName = "Risall\(index)"
            enemyRunning.append(textureAtlas.textureNamed(textureName))
        }

        addChild(enemy)
        enemyRun()
    }

    func enemyRun() {
        let moveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.012)
        let repeatAction = SKAction.repeat(moveAction, count: 20000)
        enemy.run(SKAction.repeatForever(SKAction.animate(with: enemyRunning, timePerFrame: 0.1)))
        enemy.run(repeatAction)
    }

    func enemyHit() {
        self.currentScore += 1
        projectile.removeFromParent()

        if enemyHealth > 0 {
            enemyHealth -= 1
        } else {
            enemy.removeFromParent()
        }
    }

    func createSagDead() {
        let ratio: CGFloat = 0.24
        sagDead = SKSpriteNode(imageNamed: "Sag Dead")
        sagDead.position = CGPoint(x: sag.position.x - 10, y: sag.position.y + 20)
        sagDead.zPosition = CGFloat(1.0)
        sagDead.size = CGSize(width: sagDead.size.width * ratio, height: sagDead.size.height * ratio)

        let textureAtlas = SKTextureAtlas(named: "SagGhost")
        for index in 0..<textureAtlas.textureNames.count {
            let textureName = "Ghost\(index)"
            sagGhost.append(textureAtlas.textureNamed(textureName))
        }
    }

    func sagDies() {
        sag.removeAllActions()
        createSagDead()
        sag.removeFromParent()
        addChild(sagDead)

        let moveAction = SKAction.moveBy(x: 0, y: 1.5, duration: 0.05)
        let repeatAction = SKAction.repeat(moveAction, count: 600)
        sagDead.run(SKAction.repeatForever(SKAction.animate(with: sagGhost, timePerFrame: 0.1)))
        sagDead.run(repeatAction)
    }
}
