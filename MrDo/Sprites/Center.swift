//
//  Center.swift
//  MrDo
//
//  Created by Jonathan French on 18.09.24.
//

import Foundation
import SwiftUI
import UIKit

final class Center:SwiftUISprite {
    @Published
    var collected = false
    @Published
    var collectible = false
    
    init(){
        super.init(xPos: 5, yPos: 6, frameSize: GameConstants.Size.centerSize)
        currentFrame = ImageResource(name: "CenterMonster", bundle: .main)
        collectible = false
        collected = false

    }

    func setBonusFood(level:Int) {
        currentFrame = ImageResource(name: "BonusFood1", bundle: .main)
        collectible = true
    }
    
    func collectBonusFood(){
        collected = true
        collectible = false
        currentFrame = ImageResource(name: "Blank", bundle: .main)
    }
}
