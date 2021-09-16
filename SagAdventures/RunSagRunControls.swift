//
//  RunSagRunControls.swift
//  SagAdventures
//
//  Created by Alex Freitas on 15/09/21.
//

import SpriteKit
import GameplayKit
import GameController

extension RunSagRun {
    func ObserveForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    @objc func connectControllers() {
        self.isPaused = false
        var indexNumber = 0
        for controller in GCController.controllers() {
            if controller.extendedGamepad != nil {
            controller.playerIndex = GCControllerPlayerIndex.init(rawValue: indexNumber)!
            indexNumber += 1
            setupControllerControls(controller: controller)
            }
        }
    }

    @objc func disconnectControllers() {
        self.isPaused = true
    }

    func setupControllerControls(controller: GCController) {
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            self.controllerInputDetected(gamepad: gamepad, element: element, index: controller.playerIndex.rawValue)
        }
    }

    // MARK: Controller input
    func controllerInputDetected(gamepad: GCExtendedGamepad, element: GCControllerElement, index: Int) {
        if gamepad.leftThumbstick == element {
            if gamepad.leftThumbstick.xAxis.value != 0 {
            } else if gamepad.leftThumbstick.xAxis.value == 0 { }
        }

        else if gamepad.buttonA == element {
            if gamepad.buttonA.value != 0 {
                jumpSag()
            }
        } else if gamepad.buttonB == element {
            if gamepad.buttonB.value != 0 {
                rotateSag(by: -0.5)
            }
        } else if gamepad.buttonY == element {
            if gamepad.buttonY.value != 0 {
                rotateSag(by: 0.5)
            }
        } else if gamepad.buttonX == element {
            if gamepad.buttonX.value != 0 {
                throwOrange(aim: aimingAngle(direcional: gamepad.leftThumbstick))
            }
        }
    }

    func aimingAngle(direcional: GCControllerDirectionPad) -> Double {
        let yCoordinate = Double(direcional.yAxis.value)

        return yCoordinate
    }

    func throwOrange(aim: Double) {
        createProjectile()
        addChild(projectile)

        let direction = CGPoint(x: CGFloat(1.0), y: CGFloat(aim))
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position

        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
