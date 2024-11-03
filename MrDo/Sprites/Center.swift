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
    private var points = 0
    
    init(){
        super.init(xPos: 5, yPos: 6, frameSize: GameConstants.Size.centerSize)
        currentFrame = ImageResource(name: "CenterMonster", bundle: .main)
        collectible = false
        collected = false

    }

    func setBonusFood(level:Int) {
        switch level {
        case 1:
            self.currentFrame = ImageResource(name: "BonusFood1", bundle: .main)
            points = 1000
        case 2:
            self.currentFrame = ImageResource(name: "BonusFood2", bundle: .main)
            points = 1500
        case 3:
            self.currentFrame = ImageResource(name: "BonusFood3", bundle: .main)
            points = 2000
        case 4:
            self.currentFrame = ImageResource(name: "BonusFood4", bundle: .main)
            points = 2500
        case 5...6:
            self.currentFrame = ImageResource(name: "BonusFood5", bundle: .main)
            points = 3000
        case 7...8:
            self.currentFrame = ImageResource(name: "BonusFood6", bundle: .main)
            points = 3500
        case 9...10:
            self.currentFrame = ImageResource(name: "BonusFood7", bundle: .main)
            points = 4000
        case 11...12:
            self.currentFrame = ImageResource(name: "BonusFood8", bundle: .main)
            points = 4500
        case 13...15:
            self.currentFrame = ImageResource(name: "BonusFood9", bundle: .main)
            points = 5000
        case 16...18:
            self.currentFrame = ImageResource(name: "BonusFood10", bundle: .main)
            points = 6000
        case 19...21:
            self.currentFrame = ImageResource(name: "BonusFood11", bundle: .main)
            points = 7000
        case 22...Int.max:
            self.currentFrame = ImageResource(name: "BonusFood12", bundle: .main)
            points = 8000
        default:
            currentFrame = ImageResource(name: "BonusFood1", bundle: .main)
            points = 1000
        }
        collectible = true
    }
    
    func collectBonusFood() -> Int {
        collected = true
        collectible = false
        currentFrame = ImageResource(name: "Blank", bundle: .main)
        return points
    }
}
