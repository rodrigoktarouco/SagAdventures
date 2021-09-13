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
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let sag = SKSpriteNode(imageNamed: SagAdventuresGameSceneChildName.heroName.rawValue)
    
    override func didMove(to view: SKView) {
        
        //        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createHero()
        
        
        
        print(self.size.width * 0.1)
        
        func createHero() {
            
            let newHeight = sag.size.height / 4
            let newWidth = sag.size.width / 4
            
            let heroSize = CGSize(width: newWidth, height: newHeight)
            sag.size = heroSize
            
            sag.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
            
            addChild(sag)
        }
        
        func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
        }
    }
    
    

}
