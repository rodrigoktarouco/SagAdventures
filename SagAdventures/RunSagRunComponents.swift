//
//  RunSagRunExtension.swift
//  SagAdventures
//
//  Created by Alex Freitas on 14/09/21.
//

import SpriteKit
import GameplayKit

extension RunSagRun {
    // MARK: Game components
    func createUIElements() {
        guard let view = view else { return }
        let ratio: CGFloat = 0.4
        // MARK: - Pause button
        pauseButton = SKSpriteNode(imageNamed: "Pause")
        pauseButton.name = "Pause"
        pauseButton.position = CGPoint(x: touchableJumpArea.position.x + 50, y: view.bounds.maxY - 90)
        pauseButton.zPosition = CGFloat(5.0)
        pauseButton.anchorPoint = CGPoint(x: 0, y: 0)
        pauseButton.size = CGSize(width: pauseButton.size.width * ratio, height: pauseButton.size.height * ratio)

        addChild(pauseButton)

        // MARK: - Scoreboard
        scoreboard = SKSpriteNode(imageNamed: "Scoreboard")
        scoreboard.name = "Scoreboard"
        scoreboard.position = CGPoint(x: view.bounds.maxX - 194, y: view.bounds.maxY - 90)
        scoreboard.zPosition = CGFloat(5.0)
        scoreboard.anchorPoint = CGPoint(x: 0, y: 0)
        scoreboard.size = CGSize(width: scoreboard.size.width * ratio, height: scoreboard.size.height * ratio)

        userScore = SKLabelNode(fontNamed: "Politica Black")
        userScore.text = "\(self.currentScore)"
        userScore.position = CGPoint(x: scoreboard.size.width / 2, y: scoreboard.size.height / 2 - 16)
        userScore.fontSize = 40
        userScore.fontColor = .white
        userScore.zPosition = CGFloat(6.0)

        scoreboard.addChild(userScore)
        addChild(scoreboard)
    }

    func createBackground(scene: SKScene, length: Int) {
        for _ in 0..<length {
            backgroundSprite = SKSpriteNode(imageNamed: "Background")
            backgroundSprite.anchorPoint = CGPoint(x: 0, y: 0)
            let ratioBgSize = scene.size.height / backgroundSprite.size.height
            backgroundSprite.size = CGSize(width: backgroundSprite.size.width * ratioBgSize, height: scene.size.height)
            backgroundSprite.zPosition = CGFloat(0.0)
            backgroundSprite.position = CGPoint(x: backgroundPositionX, y: 0)
            backgroundPositionX = backgroundPositionX + backgroundSprite.size.width
            addChild(backgroundSprite)
        }
    }

    func addCamera(scene: SKScene) {
        guard let view = view else { return }
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        camera = gameCamera
    }

    func createGround(scene: SKScene) {
        guard let view = view else { return }
        ground.position = CGPoint(x: view.bounds.minX, y: view.bounds.minY)
        ground.zPosition = CGFloat(1.0)
        ground.size = CGSize(width: 25000, height: 160)

        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0.0

        self.addChild(ground)
    }

    func createSag(scene: SKScene) {
        sag = SKSpriteNode(imageNamed: "Sag")
        sag.position = CGPoint(x: 30, y: 160)
        sag.zPosition = CGFloat(1.0)
        sag.size.width = CGFloat(123.0)
        sag.size.height = CGFloat(128.0)

        sag.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sag.size.width * 0.6, height: sag.size.height), center: CGPoint(x: -16, y: 0))
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
        touchableJumpArea.size = CGSize(width: (view.bounds.size.width / 2) - 100, height: view.bounds.size.height - 80)
        touchableJumpArea.name = "JumpArea"
        touchableJumpArea.anchorPoint = CGPoint(x: 0, y: 0)

        addChild(touchableJumpArea)
    }

    func createCage(scene: SKScene, quantity: Int) {
        let ratio: CGFloat = 0.2
        let gameLength = Int(ground.size.width)
        let cagesGap = gameLength / (quantity + 1)
        var cagePositionX = CGFloat(cagesGap)

        for _ in 1...quantity {
            cage = SKSpriteNode(imageNamed: "Cage")
            cage.position = CGPoint(x: cagePositionX, y: sag.position.y)
            cage.zPosition = CGFloat(1.0)
            cage.size = CGSize(width: cage.size.width * ratio, height: cage.size.height * ratio)

            cage.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cage.size.width, height: cage.size.height - 20))
            cage.physicsBody?.restitution = 0.0
            cage.physicsBody?.categoryBitMask = cageCategory
            cage.physicsBody?.collisionBitMask = sagCategory
            cage.physicsBody?.contactTestBitMask = sagCategory

            let cageTop = SKSpriteNode()
            cageTop.position = CGPoint(x: 0, y: 1)
            cageTop.zPosition = CGFloat(1.0)
            cageTop.size = CGSize(width: cage.size.width + 20, height: 10)
            cageTop.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cageTop.size.width, height: cageTop.size.height))
            cageTop.physicsBody?.restitution = 0.0

            cage.addChild(cageTop)

            cagePositionX = cagePositionX + CGFloat(cagesGap)

            addChild(cage)
        }
    }

    // MARK: Sag actions
    func runSag() {
        let moveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.01)
        let repeatAction = SKAction.repeat(moveAction, count: 8192)
        sag.run(SKAction.repeatForever(SKAction.animate(with: sagRunning, timePerFrame: 0.1)))
        sag.run(repeatAction)
    }

    func jumpSag() {
        sag.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 320.0))
    }

    func rotateSag(by radians: Double) {
        let rotateAction = SKAction.rotate(byAngle: CGFloat(radians), duration: 0.2)
        sag.run(rotateAction)
    }
}
