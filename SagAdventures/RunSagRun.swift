//
//  RunSagRun.swift
//  SagAdventures
//
//  Created by Alex Freitas on 13/09/21.
//

import SpriteKit
import GameplayKit

class RunSagRun: SKScene {
    let gameCamera = SKCameraNode()
    var ground: SKSpriteNode = SKSpriteNode()
    var sag: SKSpriteNode = SKSpriteNode()
    var sagRunning = [SKTexture]()

    override func didMove(to view: SKView) {
        guard let scene = self.scene else { return }

        addCamera(scene: scene)
        createGround(scene: scene)
        createPlayer(scene: scene)
        runSag()
    }

    override func update(_ currentTime: TimeInterval) {
        if sag.position.x > gameCamera.position.x {
            gameCamera.position.x = sag.position.x
        }
    }

    // MARK: Game components
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

    func createPlayer(scene: SKScene) {
        sag = SKSpriteNode(imageNamed: "Sag")
        sag.position = CGPoint(x: 30, y: 200)
        sag.zPosition = CGFloat(1.0)
        sag.size.width = CGFloat(123.0)
        sag.size.height = CGFloat(128.0)

        sag.physicsBody = SKPhysicsBody(rectangleOf: sag.size)

        let textureAtlas = SKTextureAtlas(named: "SagRunning")
        for index in 0..<textureAtlas.textureNames.count {
            let textureName = "Sag\(index)"
            sagRunning.append(textureAtlas.textureNamed(textureName))
        }

        self.addChild(sag)
    }

    // MARK: Sag actions
    func runSag() {
        let moveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.01)
        let repeatAction = SKAction.repeat(moveAction, count: 500)
        sag.run(SKAction.repeatForever(SKAction.animate(with: sagRunning, timePerFrame: 0.1)))
        sag.run(repeatAction)
    }

    func jumpSag() {
        sag.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 600.0))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      // 1 - Choose one of the touches to work with
      guard let touch = touches.first else {
        return
      }
      let touchLocation = touch.location(in: self)
      
      // 2 - Set up initial location of projectile
      let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = sag.position
      
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
    
}
