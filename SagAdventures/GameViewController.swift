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

//        if let view = self.view as! SKView? {
//            if let scene = SKScene(fileNamed: "RunSagRun") {
//                scene.scaleMode = .aspectFill
//                scene.scaleMode = .resizeFill
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
//        }

        let scene = StartGameScene(size: view.bounds.size)
        let skView = view as! SKView
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
//        let scene = GameScene(size: view.bounds.size)
//        let skView = view as! SKView
//        skView.showsFPS = false
//        skView.showsNodeCount = false
//        skView.ignoresSiblingOrder = true
//        scene.scaleMode = .resizeFill
//        skView.presentScene(scene)
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
