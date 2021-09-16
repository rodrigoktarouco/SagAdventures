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
    var projectile = SKSpriteNode()
    
    // MARK: UI elements
    var pauseButton = SKSpriteNode()
    var scoreboard = SKSpriteNode()
    var userScore = SKLabelNode()
    var touchableJumpArea = SKSpriteNode()
    var currentScore = 0
    
    // MARK: Physics categories
    let sagCategory: UInt32 = 0x00000001
    let cageCategory: UInt32 = 0x00000001 << 1
    let enemyCategory: UInt32 = 0x00000001 << 2
    let orangeCategory: UInt32 = 0x00000001 << 4

    // MARK: Game challenges
    var cage = SKSpriteNode()
    var enemy = SKSpriteNode()
    var enemyRunning = [SKTexture]()
    var enemyCreated = false
    var enemyHealth = 10
    
    override func didMove(to view: SKView) {
        guard let scene = self.scene else { return }
        ObserveForGameControllers()

        createBackground(scene: scene, length: 12)
        addCamera(scene: scene)
        createGround(scene: scene)
        createUIElements()
        createSag(scene: scene)
        createTouchableJumpArea(scene: scene)
        createCages(quantity: 14)
        runSag()

        physicsWorld.contactDelegate = self

        let backgroundMusic = SKAudioNode(fileNamed: "Mr.ruiZ - Jamaica Jive copy.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func update(_ currentTime: TimeInterval) {
        userScore.text = "\(self.currentScore)"

        guard let scene = scene else { return }
        
        let sagRefPosition = sag.position.x + 220
        if sagRefPosition > gameCamera.position.x {
            gameCamera.position.x = sagRefPosition
            touchableJumpArea.position.x = sagRefPosition - scene.size.width / 2
            pauseButton.position.x = touchableJumpArea.position.x + 50
            scoreboard.position.x = touchableJumpArea.position.x + 650
        }

        if sag.position.x > 12800 && !enemyCreated {
            enemyAppearance()
            enemyCreated = true
        }

        if currentScore > enemyHealth {
            finishTheGame()
        }
    }
    
    // MARK: User input
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // MARK: - User touch area
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // MARK: - Jump touch area
        if touchableJumpArea.frame.contains(touchLocation) {
            jumpSag()
        }
        
        // MARK: - Pause button
        if pauseButton.frame.contains(touchLocation) {
            if isPaused {
                isPaused = false
            } else {
                isPaused = true
            }
        }

        // MARK: - Throw projectile based on touch
        throwProjectileTouch(touchLocation: touchLocation)
    }

    // MARK: Physiscs contact delegate
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // MARK: - Sag touches the cage
        if collision == sagCategory | cageCategory {
            sagHit()
        }

        // MARK: - Sag touches the enemy
        if collision == sagCategory | enemyCategory {
            sagHit()
        }

        // MARK: - Orange hits the enemy
        if collision == orangeCategory | enemyCategory {
            enemyHit()
        }
    }
    
    func finishTheGame() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: true)
        view?.presentScene(gameOverScene, transition: reveal)
    }
}
