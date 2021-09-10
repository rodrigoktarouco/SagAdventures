//
//  GameViewController.swift
//  SagAdventures
//
//  Created by Rodrigo Kroef Tarouco on 10/09/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let screenSize = CGSize(width: DefinedScreenWidth, height: DefinedScreenHeight)
            
            let scene = GameScene(size: screenSize)
            
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
        
            view.showsFPS = false
            view.showsNodeCount = false
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            
        }

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
