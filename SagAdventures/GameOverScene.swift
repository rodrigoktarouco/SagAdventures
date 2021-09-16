//
//  GameOverScene.swift
//  SagAdventures
//
//  Created by Rodrigo Kroef Tarouco on 15/09/21.
//

import Foundation
import GameplayKit
import SpriteKit

class GameOverScene: SKScene {
    
    var didWin: Bool
    var levelToSend: Int
    
    required init?(coder aDecoder: NSCoder) { fatalError("LevelEnd init not implemented") }
    
    init(size: CGSize, didWin: Bool, playAgain: Int) {
        self.didWin = didWin
        levelToSend = didWin ? playAgain : playAgain - 1
        super.init(size: size)
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        buildView()
    }
    
    private func buildView() {
        /// Background
        //backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        backgroundColor = SKColor.black.withAlphaComponent(0.1)
        
        
        /// Main message text
        let winLabel = SKLabelNode(text: didWin ? "Mandou muito bem!" : "Tente novamente")
        winLabel.fontName = "Politica"
        winLabel.fontSize = 40
        winLabel.fontColor = .white
        winLabel.position = CGPoint(x: frame.midX, y: frame.midY + 35)
        addChild(winLabel)
        
        /// Action tap button
        let tapButton = SKSpriteNode(texture: SKTexture(imageNamed: didWin ? "Play" : "Play"))
        tapButton.size = CGSize(width: didWin ? 105 : 105, height: 49)
        tapButton.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        addChild(tapButton)
    
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendToLevel(levelToSend)
    }
    
    // MARK: - Navigation
    private func sendToLevel(_ level: Int) {
            
        var nextScene: SKScene?
        
        switch level {
        case 1:
            nextScene = RunSagRun(size: size)
        default:
            nextScene = RunSagRun(size: size)
        }

        guard let scene = nextScene else { fatalError("Scene for level \(level) not found") }
        let transition = SKTransition.flipHorizontal(withDuration: 1.0)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: transition)
    }
}
        
//        // 2
//        let message = won
//
//        // 3
//        let label = SKLabelNode(fontNamed: "Politica")
//        label.text = message
//        label.fontSize = 40
//        label.fontColor = SKColor.white
//        label.position = CGPoint(x: size.width/2, y: size.height/2)
//        addChild(label)
//
//        // 4
//        run(SKAction.sequence([
//            SKAction.wait(forDuration: 3.0),
//            SKAction.run() { [weak self] in
//                // 5
//                guard let `self` = self else { return }
//                let reveal = SKTransition.flipHorizontal(withDuration: 1.0)
//                let scene =
//                self.view?.presentScene(scene, transition:reveal)
//            }
//        ]))
//    }


