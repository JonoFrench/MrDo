//
//  ExtraMonster.swift
//  MrDo
//
//  Created by Jonathan French on 23.10.24.
//

import Foundation
import SwiftUI

enum ExtraType {
    case letter,monster
}

final class ExtraMonsterArray: ObservableObject {
    @Published var monsters: [ExtraMonster] = []
    var monsterCount = 0
    var killCount = 0
    var letterAdded = false
    
    func move() {
        for monster in monsters {
            monster.move()
            monster.animate()
        }
    }

    func still() {
        for monster in monsters where monster.monsterState == .moving || monster.monsterState == .chasing {
            monster.monsterState = .still
        }
    }

    func remove(id:UUID) {
        if let index = monsters.firstIndex(where: {$0.id == id}) {
            monsters.remove(at: index)
            killCount += 1
        }
    }
    
    func add(xPos:Int,yPos:Int,letterPos:Int) {
        let monster = ExtraMonster(xPos: xPos, yPos:yPos,type: letterAdded ? .monster : .letter,letter: letterPos)
        monsters.append(monster)
        monsterCount += 1
        letterAdded = true
        if monsterCount == 6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                monsters[0].monsterState = .appearing
            }
        }
    }
}

final class ExtraMonster:Monster,Moveable,Animatable {
    static var animateFrames: Int = 0
    static var speed:Int = GameConstants.monsterSpeed
    
    private var walkRightFrames: [UIImage] = []
    private var walkLeftFrames: [UIImage] = []
    private var walkUpFrames: [UIImage] = []
    private var walkDownFrames: [UIImage] = []
    
    private var extraFrames: [UIImage] = []
//    private var extraLeftFrames: [UIImage] = []
//    private var extraUpFrames: [UIImage] = []
//    private var extraDownFrames: [UIImage] = []
    
//    private var stripeRightFrames: [UIImage] = []
//    private var stripeLeftFrames: [UIImage] = []
//    private var stripeUpFrames: [UIImage] = []
//    private var stripeDownFrames: [UIImage] = []
    
    private var deadExtraFrame: UIImage = UIImage()
    
    private var appearCount = 0
    private var actualAnimationFrame = 0
    private var increaseSpeedCounter = 0
    var extraType: ExtraType = .letter
    private var letter = 0
    init(xPos: Int, yPos: Int, type:ExtraType, letter: Int) {
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 28, height:  28))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 52, height:  52))
#endif
        extraType = type
        setImages()
        currentImage = extraType == .monster ? rightFrames[0] : extraFrames[0]
        if extraType == .letter {
            monsterState = .still
        }
        actualAnimationFrame = 0
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = resolvedInstance.assetDimensionStep
            position.y -= resolvedInstance.assetDimension
        }
        gridOffsetY = 0
        self.letter = letter
    }
    
    func squash() {
        monsterState = .falling
        currentImage = deadFrame
    }
    
    func kill(){
        currentImage = UIImage(resource: ImageResource(name: "Points500", bundle: .main))
        monsterState = .dead
        currentAnimationFrame = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            let monsterID:[String: UUID] = ["id": self.id]
            NotificationCenter.default.post(name: .notificationKillExtraMonster, object: nil, userInfo: monsterID)
        }
    }
    
    func fall(){
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            moveCounter += 1
            position.y += screenData.assetDimensionStep
            if moveCounter == 8 {
                moveCounter = 0
                if screenData.levelData.checkFalling(xPos: xPos, yPos: yPos) || yPos == screenData.screenDimensionY {
                    kill()
                }
                yPos += 1
            }
        }
    }
    
    func appear(){
        guard monsterState == .appearing else {return}
        speedCounter += 1
        if speedCounter == currentSpeed {
            speedCounter = 0
            position.y += moveDistance
            if gridOffsetY == 7 {
                monsterState = .moving
                gridOffsetY = 0
                monsterDirection = nextDirection()
            }
            gridOffsetY += 1
        }
    }
    
    func move() {
        guard monsterState != .dead && monsterState != .still else { return }
        if monsterState == .falling {
            fall()
        } else if monsterState == .appearing {
            appear()
        } else {
            monsterMove()
        }
    }
    
    func animate() {
        guard monsterState != .dead else { return }
        currentAnimationFrame += 1
        if currentAnimationFrame == 8 {
            currentAnimationFrame = 0
            if monsterState == .moving || monsterState == .chasing || monsterState == .still || monsterState == .appearing {
                switch monsterDirection {
                case .left:
                    currentImage = extraType == .monster ? leftFrames[actualAnimationFrame] : extraFrames[actualAnimationFrame]
                case .right:
                    currentImage = extraType == .monster ? rightFrames[actualAnimationFrame] : extraFrames[actualAnimationFrame]
                case .up:
                    currentImage = extraType == .monster ? upFrames[actualAnimationFrame] : extraFrames[actualAnimationFrame]
                case .down:
                    currentImage = extraType == .monster ? downFrames[actualAnimationFrame] : extraFrames[actualAnimationFrame]
                }
                actualAnimationFrame += 1
                if actualAnimationFrame == 2 {
                    actualAnimationFrame = 0
                }
                
            }
        }
    }
    
    private func setImages() {
        for i in 0..<2 {
            walkRightFrames.append(getTile(name: "BlueMonsters", pos: i)!)
        }
        for i in 2..<4 {
            walkDownFrames.append(getTile(name: "BlueMonsters", pos: i)!)
        }
        for i in 4..<6 {
            walkLeftFrames.append(getTile(name: "BlueMonsters", pos: i)!)
        }
        for i in 6..<8 {
            walkUpFrames.append(getTile(name: "BlueMonsters", pos: i)!)
        }
        for i in 1..<3 {
            extraFrames.append(getTile(name: "ExtraMonsters", pos: i)!)
        }
        for i in 4..<6 {
            extraFrames.append(getTile(name: "ExtraMonsters", pos: i)!)
        }
        for i in 7..<9 {
            extraFrames.append(getTile(name: "ExtraMonsters", pos: i)!)
        }
        for i in 10..<12 {
            extraFrames.append(getTile(name: "ExtraMonsters", pos: i)!)
        }

        if extraType == .letter {
            leftFrames = [extraFrames[letter * 2],extraFrames[letter * 2 + 1]]
            rightFrames = [extraFrames[letter * 2],extraFrames[letter * 2 + 1]]
            upFrames = [extraFrames[letter * 2],extraFrames[letter * 2 + 1]]
            downFrames = [extraFrames[letter * 2],extraFrames[letter * 2 + 1]]

        } else {
            leftFrames = walkLeftFrames
            rightFrames = walkRightFrames
            upFrames = walkUpFrames
            downFrames = walkDownFrames
        }
//        leftFrames = stripeLeftFrames
//        rightFrames = stripeRightFrames
//        upFrames = stripeUpFrames
//        downFrames = stripeDownFrames

    }
}
