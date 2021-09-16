//
//  StartGameScene.swift
//  SagAdventures
//
//  Created by Alex Freitas on 16/09/21.
//

import SpriteKit
import GameplayKit

class StartGameScene: SKScene {
    var initialBackground = SKSpriteNode()
    var aboutGameButton = SKSpriteNode()
    var startGameButton = SKSpriteNode()
    var settingsButton = SKSpriteNode()

    override func didMove(to view: SKView) {
        createBackground(view: view)
        addStartGameButton(view: view)
        addAboutGameButton(view: view)
        addSettingsButton(view: view)
    }

    func createBackground(view: SKView) {
        initialBackground = SKSpriteNode(imageNamed: "Initial Background")
        initialBackground.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        initialBackground.zPosition = CGFloat(1.0)
        initialBackground.scale(to: view.frame.size)

        addChild(initialBackground)
    }

    func addStartGameButton(view: SKView) {
        let ratio: CGFloat = 0.55
        startGameButton = SKSpriteNode(imageNamed: "Start Game Button")
        startGameButton.name = "Start"
        startGameButton.anchorPoint = CGPoint(x: 1, y: 1)
        startGameButton.position = CGPoint(x: view.bounds.maxX - 70, y: view.bounds.maxY - 60)
        startGameButton.zPosition = CGFloat(2.0)
        startGameButton.size = CGSize(width: startGameButton.size.width * ratio, height: startGameButton.size.height * ratio)

        addChild(startGameButton)
    }

    func addAboutGameButton(view: SKView) {
        let ratio: CGFloat = 0.55
        aboutGameButton = SKSpriteNode(imageNamed: "About Button")
        aboutGameButton.name = "About"
        aboutGameButton.anchorPoint = CGPoint(x: 1, y: 1)
        aboutGameButton.position = CGPoint(x: startGameButton.frame.maxX, y: startGameButton.frame.minY - 20)
        aboutGameButton.zPosition = CGFloat(2.0)
        aboutGameButton.size = CGSize(width: aboutGameButton.size.width * ratio, height: aboutGameButton.size.height * ratio)

        addChild(aboutGameButton)
    }

    func addSettingsButton(view: SKView) {
        let ratio: CGFloat = 0.5
        settingsButton = SKSpriteNode(imageNamed: "Config Button")
        settingsButton.name = "Settings"
        settingsButton.anchorPoint = CGPoint(x: 0, y: 0)
        settingsButton.position = CGPoint(x: view.bounds.minX + 40, y: view.bounds.minY + 40)
        settingsButton.zPosition = CGFloat(2.0)
        settingsButton.size = CGSize(width: settingsButton.size.width * ratio, height: settingsButton.size.height * ratio)

        addChild(settingsButton)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)

        if startGameButton.frame.contains(touchLocation) {
            let reveal = SKTransition.fade(withDuration: 0.5)
            let scene = RunSagRun(size: self.size)
            view?.presentScene(scene, transition: reveal)
        }
    }
}
