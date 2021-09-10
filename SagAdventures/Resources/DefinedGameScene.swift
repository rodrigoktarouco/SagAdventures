//
//  DefinedGameScene.swift
//  SagAdventures
//
//  Created by Giovani Nícolas Bettoni on 10/09/21.
//

import Foundation
import SpriteKit

let DefinedScreenWidth = UIScreen.main.bounds.width
let DefinedScreenHeight = UIScreen.main.bounds.height

enum SagAdventuresGameSceneChildName: String {
    case heroName = "Sag"
    case scoreName = "score"
    case retryName = "retry"
    case enemyName = "enemy"
}

enum SagAdventuresGameSceneActionKey: String {
    case walkAction = "walk"
    case jumpAction = "jump"
}

enum SagAdventuresGameSceneZPosition: CGFloat {
    case backgroundZPosition = 0
}
