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
    var player: SKSpriteNode = SKSpriteNode()

    override func didMove(to view: SKView) {
        guard let scene = self.scene else { return }

        addCamera(scene: scene)
        createGround(scene: scene)
        createPlayer(scene: scene)
        runSag()
    }

    override func update(_ currentTime: TimeInterval) {
        if player.position.x > gameCamera.position.x {
            gameCamera.position.x = player.position.x
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
        player = SKSpriteNode(imageNamed: "Sag")
        player.position = CGPoint(x: 30, y: 200)
        player.zPosition = CGFloat(1.0)
        player.size.width = CGFloat(123.0)
        player.size.height = CGFloat(128.0)

        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)

        self.addChild(player)
    }

    // MARK: Sag actions
    func runSag() {
        let moveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.01)
        let repeatAction = SKAction.repeat(moveAction, count: 500)
        player.run(repeatAction)
    }

    func jumpSag() {
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 600.0))
    }
}
