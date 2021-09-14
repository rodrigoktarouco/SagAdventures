//
//  RunSagRun.swift
//  SagAdventures
//
//  Created by Alex Freitas on 13/09/21.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let enemy   : UInt32 = 0b1       // 1
  static let projectile: UInt32 = 0b10      // 2
}

class RunSagRun: SKScene, SKPhysicsContactDelegate {
    // MARK: Visual elements
    var backgroundSprite = SKSpriteNode()
    let gameCamera = SKCameraNode()
    var ground = SKSpriteNode()
    var sag = SKSpriteNode()
    var sagRunning = [SKTexture]()
    var cage = SKSpriteNode()

    // MARK: UI elements
    var pauseButton = SKSpriteNode()
    var scoreboard = SKSpriteNode()
    var touchableJumpArea = SKSpriteNode()

    // MARK: Physics categories
    let sagCategory: UInt32 = 0x00000001 << 0
    let cageCategory: UInt32 = 0x00000001 << 1


    override func didMove(to view: SKView) {
        guard let scene = self.scene else { return }

        createBackground(scene: scene)
        addCamera(scene: scene)
        createGround(scene: scene)
        createUIElements()
        createSag(scene: scene)
        createTouchableJumpArea(scene: scene)
        createCage(scene: scene)
        runSag()
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(addEnemy),
                SKAction.wait(forDuration: 4.0)
                ])
            ))
        
        self.physicsWorld.contactDelegate = self
        
        let backgroundMusic = SKAudioNode(fileNamed: "Mr.ruiZ - Jamaica Jive copy.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)

    }

    override func update(_ currentTime: TimeInterval) {
        guard let scene = scene else { return }
        if sag.position.x > gameCamera.position.x {
            gameCamera.position.x = sag.position.x
            touchableJumpArea.position.x = sag.position.x - scene.size.width/2
            pauseButton.position.x = touchableJumpArea.position.x + 50
        }
    }

    // MARK: Game components
    func createUIElements() {
        pauseButton = SKSpriteNode(imageNamed: "Pause")
        pauseButton.name = "Pause"
        guard let view = view else { return }
        pauseButton.position = CGPoint(x: touchableJumpArea.position.x + 50, y: view.bounds.maxY - pauseButton.size.height*0.6)
        pauseButton.zPosition = CGFloat(5.0)
        pauseButton.anchorPoint = CGPoint(x: 0, y: 0)
        pauseButton.size = CGSize(width: pauseButton.size.width*0.4, height: pauseButton.size.height*0.4)

        addChild(pauseButton)
    }

    func createBackground(scene: SKScene) {
        backgroundSprite = SKSpriteNode(imageNamed: "Background")
        backgroundSprite.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundSprite.position = CGPoint(x: 0, y: 0)
        let ratioBgSize = scene.size.height / backgroundSprite.size.height
        backgroundSprite.size = CGSize(width: backgroundSprite.size.width*ratioBgSize, height: scene.size.height)
        backgroundSprite.zPosition = CGFloat(0.0)

        addChild(backgroundSprite)
    }

    func addCamera(scene: SKScene) {
        guard let view = view else { return }
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        camera = gameCamera
    }

    func createGround(scene: SKScene) {
        ground = self.childNode(withName: "ground") as! SKSpriteNode
        ground = SKSpriteNode(color: .clear, size: CGSize(width: scene.size.width*2, height: 160.0))
        ground.position = CGPoint(x: scene.size.width / 2, y: 0.0)
        ground.zPosition = CGFloat(1.0)

        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0.0

        self.addChild(ground)
    }

    func createSag(scene: SKScene) {
        sag = SKSpriteNode(imageNamed: "Sag")
        sag.position = CGPoint(x: 30, y: 200)
        sag.zPosition = CGFloat(1.0)
        sag.size.width = CGFloat(123.0)
        sag.size.height = CGFloat(128.0)

        sag.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sag.size.width*0.6, height: sag.size.height), center: CGPoint(x: -16, y: 0))
        sag.physicsBody?.restitution = 0.0
        sag.physicsBody?.categoryBitMask = sagCategory

        let textureAtlas = SKTextureAtlas(named: "SagRunning")
        for index in 0..<textureAtlas.textureNames.count {
            let textureName = "Sag\(index)"
            sagRunning.append(textureAtlas.textureNamed(textureName))
        }

        self.addChild(sag)
    }

    func createTouchableJumpArea(scene: SKScene) {
        guard let view = view else { return }
        touchableJumpArea.position = CGPoint(x: view.bounds.minX, y: view.bounds.minY)
        touchableJumpArea.zPosition = CGFloat(3.0)
        touchableJumpArea.size = CGSize(width: view.bounds.size.width/2-100, height: view.bounds.size.height-80)
        touchableJumpArea.name = "JumpArea"
        touchableJumpArea.anchorPoint = CGPoint(x: 0, y: 0)

        addChild(touchableJumpArea)
    }

    func createCage(scene: SKScene) {
        cage = SKSpriteNode(imageNamed: "Cage")
        cage.position = CGPoint(x: scene.size.width/2, y: 100)
        cage.zPosition = CGFloat(1.0)
        cage.size = CGSize(width: cage.size.width*0.2, height: cage.size.height*0.2)

        cage.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cage.size.width, height: cage.size.height))
        cage.physicsBody?.restitution = 0.0
        cage.physicsBody?.categoryBitMask = cageCategory
        cage.physicsBody?.collisionBitMask = sagCategory
        cage.physicsBody?.contactTestBitMask = sagCategory

        addChild(cage)
    }

    // MARK: Sag actions
    func runSag() {
        let moveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.01)
        let repeatAction = SKAction.repeat(moveAction, count: 500)
        sag.run(SKAction.repeatForever(SKAction.animate(with: sagRunning, timePerFrame: 4)))
        sag.run(repeatAction)
    }

    func jumpSag() {
        sag.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 320.0))
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
        projectile.size = CGSize(width: projectile.size.width*0.5, height: projectile.size.height*0.5)
        projectile.position = CGPoint(x: sag.position.x+36, y: sag.position.y-6)
        projectile.zPosition = CGFloat(1.5)
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width*0.6)

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
        let lumberjack = SKSpriteNode(imageNamed: "Sag")
        
        lumberjack.physicsBody = SKPhysicsBody(rectangleOf: lumberjack.size) // 1
        lumberjack.physicsBody?.isDynamic = false // 2
        lumberjack.physicsBody?.categoryBitMask = PhysicsCategory.enemy // 3
        lumberjack.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        lumberjack.physicsBody?.collisionBitMask = PhysicsCategory.none // 5

        
        // Where the enemy is going to appear 
        let actualY =  lumberjack.size.height/2
        
        let actualX = size.width + lumberjack.size.width/2
        
        lumberjack.position = CGPoint(x: actualX, y: actualY)
        
        addChild(lumberjack)
        
        // Set enemy speed
        let actualDuration = random(min: CGFloat(6), max: CGFloat(8))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -lumberjack.size.width/2, y: actualY),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        lumberjack.run(SKAction.sequence([actionMove, actionMoveDone]))
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
      print("Hit")
      projectile.removeFromParent()
      enemy.removeFromParent()
    }

}
