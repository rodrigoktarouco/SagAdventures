//
//  GameScene.swift
//  SagAdventures
//
//  Created by Rodrigo Kroef Tarouco on 10/09/21.
//


import SpriteKit
import GameplayKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    
    
    //    let enemy = SKSpriteNode(imageNamed: SagAdventuresGameSceneChildName.enemy.rawValue)
    
    lazy var playAbleRect: CGRect = {
        let maxAspectRatio: CGFloat = 18.5/8.0 // iPhone 12"Pro Max
        let maxAspectRatioWidth = self.size.height / maxAspectRatio
        let playableMargin = (self.size.width - maxAspectRatioWidth) / 3.0
        return CGRect(x: playableMargin, y: 0, width: maxAspectRatioWidth, height: self.size.height)
    }()
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.1, y: 0.2)
        createHero()
        
    }
    
    
    
    // MARK: - Create Hero
    func createHero() {
        
        let sag = SKSpriteNode(imageNamed: SagAdventuresGameSceneChildName.heroName.rawValue)
        
        let newHeight = sag.size.height / 4
        let newWidth = sag.size.width / 4
        let heroSize = CGSize(width: newWidth, height: newHeight)
        sag.size = heroSize
        
        let xPosition: CGFloat = (DefinedScreenWidth * 0.01)
        let yPosition: CGFloat = (sag.size.height * 0.05)
        print("Sag init pos: (\(xPosition), \(yPosition))")
        sag.position = CGPoint(x: xPosition, y: yPosition)
        
        addChild(sag)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
