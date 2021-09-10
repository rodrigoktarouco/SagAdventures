//
//  DefinedGameScene.swift
//  SagAdventures
//
//  Created by Giovani Nícolas Bettoni on 10/09/21.
//

import Foundation
import SpriteKit


enum SagAdventuresGameSceneChildName: String {
    case heroName = "Sag"
    case scoreName = "score"
    case retryName = "retry"
    case enemy = "enemy"
}

enum SagAdventuresGameSceneActionKey: String {
    case walkAction = "walk"
    case jumpAction = "jump"
}

enum SagAdventuresGameSceneZPosition: CGFloat {
    case backgroundZPosition = 0
}
