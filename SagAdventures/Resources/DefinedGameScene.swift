//
//  DefinedGameScene.swift
//  SagAdventures
//
//  Created by Giovani Nícolas Bettoni on 10/09/21.
//

import Foundation
import SpriteKit


enum SagAdventuresGameSceneChildName: String {
    case heroName = "hero"
    case scoreName = "score"
    case retryName = "retry"
}

enum SagAdventuresGameSceneActionKey: String {
    case walkAction = "walk"
}

enum SagAdventuresGameSceneZPosition: CGFloat {
    case backgroundZPosition = 0
}
