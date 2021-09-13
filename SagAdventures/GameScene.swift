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
