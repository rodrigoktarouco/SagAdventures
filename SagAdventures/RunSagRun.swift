//
//  RunSagRun.swift
//  SagAdventures
//
//  Created by Alex Freitas on 13/09/21.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let enemy: UInt32 = 0b1            // 1
    static let projectile: UInt32 = 0b10      // 2
}

class RunSagRun: SKScene, SKPhysicsContactDelegate {
    // MARK: Visual elements
    var backgroundPositionX: CGFloat = 0.0
    var backgroundSprite = SKSpriteNode()
    let gameCamera = SKCameraNode()
    var ground = SKSpriteNode()
    var sag = SKSpriteNode()
    var sagRunning = [SKTexture]()
    var cage = SKSpriteNode()
    var lumberjack = SKSpriteNode()
    
    // MARK: UI elements
    var pauseButton = SKSpriteNode()
    var scoreboard = SKSpriteNode()
    var userScore = SKLabelNode()
    var touchableJumpArea = SKSpriteNode()
    var currentScore = 0
    
    // MARK: Physics categories
    let sagCategory: UInt32 = 0x00000001 << 0
    let cageCategory: UInt32 = 0x00000001 << 1
    
    override func didMove(to view: SKView) {
        guard let scene = self.scene else { return }
        ObserveForGameControllers()
        createBackground(scene: scene, length: 5)
        addCamera(scene: scene)
        createGround(scene: scene)
        createUIElements()
        createSag(scene: scene)
        createTouchableJumpArea(scene: scene)
        createCage(scene: scene, quantity: 10)
        runSag()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addEnemy), SKAction.wait(forDuration: 4.0)])))
        
        self.physicsWorld.contactDelegate = self
        
        let backgroundMusic = SKAudioNode(fileNamed: "Mr.ruiZ - Jamaica Jive copy.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let scene = scene else { return }
        
        let sagRefPosition = sag.position.x + 220
        if sagRefPosition > gameCamera.position.x {
            gameCamera.position.x = sagRefPosition
            touchableJumpArea.position.x = sagRefPosition - scene.size.width / 2
            pauseButton.position.x = touchableJumpArea.position.x + 50
            scoreboard.position.x = touchableJumpArea.position.x + 650
        }
        userScore.text = "\(self.currentScore)"
    }
    
    // MARK: User input
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // MARK: Jump touch area
        if touchableJumpArea.frame.contains(touchLocation) {
            jumpSag()
        }
        
        // MARK: Pause button
        if pauseButton.frame.contains(touchLocation) {
            if isPaused {
                isPaused = false
            } else {
                isPaused = true
            }
        }
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "Orange")
        projectile.size = CGSize(width: projectile.size.width * 0.5, height: projectile.size.height * 0.5)
        projectile.position = CGPoint(x: sag.position.x + 36, y: sag.position.y - 6)
        projectile.zPosition = CGFloat(1.5)
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width * 0.6)
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if offset.x < 0 { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    } 
    // Enemy position
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addEnemy() {
        // Create sprite
        let lumberjack = SKSpriteNode(imageNamed: "Risall")
        
        lumberjack.physicsBody = SKPhysicsBody(rectangleOf: lumberjack.size) // 1
        lumberjack.physicsBody?.affectedByGravity = false
        lumberjack.physicsBody?.isDynamic = false // 2
        lumberjack.physicsBody?.categoryBitMask = PhysicsCategory.enemy // 3
        lumberjack.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        lumberjack.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        lumberjack.size = CGSize(width: sag.size.width, height: sag.size.height * 1.5)
        
        // Where the enemy is going to appear 
        
        //        let actualX = size.width + lumberjack.size.width/2
        //        lumberjack.position = CGPoint(x: actualX, y: actualY)
        lumberjack.position = CGPoint(x: CGFloat(UIScreen.main.bounds.maxX + lumberjack.size.width + 50), y: 160)
        let actualY =  lumberjack.position.y
        
        print("posSL>>>>>> \(sag.position) e \(lumberjack.position)")
        print("posLumbX >>>\(lumberjack.position.x)")
        
        addChild(lumberjack)
        
        // Set enemy speed
        let actualDuration = random(min: CGFloat(3), max: CGFloat(6))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -lumberjack.size.width/2, y: actualY),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, didWin: false, playAgain: 1)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        lumberjack.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    // MARK: Physiscs contact delegate
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == sagCategory | cageCategory {
            print("sag morre")
        }
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.enemy != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode,
               let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithEnemy(projectile: projectile, enemy: enemy)
            }
        }
    }
    
    func projectileDidCollideWithEnemy(projectile: SKSpriteNode, enemy: SKSpriteNode) {
        self.currentScore += 1
        print("Hit")
        projectile.removeFromParent()
        enemy.removeFromParent()
        if self.currentScore >= 4 {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, didWin: true, playAgain: 1)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
}
