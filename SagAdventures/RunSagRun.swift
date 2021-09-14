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


class RunSagRun: SKScene {
    var backgroundSprite = SKSpriteNode()
    let gameCamera = SKCameraNode()
    var ground: SKSpriteNode = SKSpriteNode()
    var sag: SKSpriteNode = SKSpriteNode()
    var sagRunning = [SKTexture]()
    var touchableJumpArea = SKSpriteNode()

    override func didMove(to view: SKView) {
        guard let scene = self.scene else { return }

        createBackground(scene: scene)
        addCamera(scene: scene)
        createGround(scene: scene)
        createSag(scene: scene)
        createTouchableJumpArea(scene: scene)
        runSag()
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(addEnemy),
                SKAction.wait(forDuration: 4.0)
                ])
            ))
}

    override func update(_ currentTime: TimeInterval) {
        guard let scene = scene else { return }
        if sag.position.x > gameCamera.position.x {
            gameCamera.position.x = sag.position.x
            touchableJumpArea.position.x = sag.position.x - scene.size.width/2
        }
    }

    // MARK: Game components
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

        self.addChild(ground)
    }

    func createSag(scene: SKScene) {
        sag = SKSpriteNode(imageNamed: "Sag")
        sag.position = CGPoint(x: 30, y: 200)
        sag.zPosition = CGFloat(1.0)
        sag.size.width = CGFloat(123.0)
        sag.size.height = CGFloat(128.0)

        sag.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sag.size.width*0.6, height: sag.size.height), center: CGPoint(x: -16, y: 0))

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

        if touchableJumpArea.frame.contains(touchLocation) {
            jumpSag()
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
    
    // Monster positions
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    func addEnemy() {
        
        // Create sprite
        let lumberjack = SKSpriteNode(imageNamed: "Sag")
        
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
    
}

extension RunSagRun: SKPhysicsContactDelegate {
    
}

