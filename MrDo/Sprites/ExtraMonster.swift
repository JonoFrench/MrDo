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
    var squashCount = 0
    
    func move() {
        for monster in monsters {
            monster.move()
            monster.animate()
        }
    }
    
    func still() {
        for monster in monsters where monster.monsterState != .falling {
            monster.monsterState = .still
        }
    }
    
    func moving() {
        for monster in monsters where monster.monsterState == .still {
            monster.monsterState = .moving
        }
    }
    
    func remove(id:UUID) {
        if let index = monsters.firstIndex(where: {$0.id == id}) {
            monsters.remove(at: index)
            killCount += 1
        }
    }
    
    func add(xPos:Int,yPos:Int,letterPos:Int) {
        let monster = ExtraMonster(xPos: xPos, yPos:yPos,type: letterAdded ? .bluemonster : .letter,letter: letterPos)
        monsters.append(monster)
        monsterCount += 1
        letterAdded = true
        if monsterCount == 6 {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(GameConstants.Delay.extraLetterDelay))
                monsters[0].monsterState = .appearing
            }
        }
    }
}

final class ExtraMonster:Monster,Moveable,Animatable {
    static var speed:Int = GameConstants.Speed.monsterSpeed
    
    private var walkRightFrames: [UIImage] = []
    private var walkLeftFrames: [UIImage] = []
    private var walkUpFrames: [UIImage] = []
    private var walkDownFrames: [UIImage] = []
    
    private var extraFrames: [UIImage] = []
    
    private var appearCount = 0
    private var increaseSpeedCounter = 0
    private var letter = 0
    
    init(xPos: Int, yPos: Int, type:MonsterType, letter: Int) {
        super.init(xPos: xPos, yPos: yPos, frameSize: GameConstants.Size.extraMonsterSize)
        monsterType = type
        self.letter = letter
        setImages()
        currentImage = monsterType == .bluemonster ? rightFrames[0] : extraFrames[0]
        if monsterType == .letter { monsterState = .still }
        actualAnimationFrame = 0
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = screenData.assetDimensionStep
            position.y -= screenData.assetDimension
        }
        gridOffsetY = 0
    }
    
    func squash() {
        monsterState = .falling
        currentImage = deadFrame
    }
    
    func kill(){
        currentImage =  deadFrame
        monsterState = .dead
        currentAnimationFrame = 0
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.monsterKillDelay))
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
                if screenData.levelData.checkFalling(xPos: xPos, yPos: yPos) || yPos == screenData.screenDimensionY-1 {
                    kill()
                }
                yPos += 1
            }
        }
    }
    
    func appear(){
        guard monsterState == .appearing else { return }
        speedCounter += 1
        if speedCounter == currentSpeed {
            speedCounter = 0
            position.y += moveDistance
            if gridOffsetY == 7 {
                monsterState = .moving
                monsterDirection = nextDirection()
                setOffsets(direction: monsterDirection)
            } else { gridOffsetY += 1 }
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
            if monsterType == .swallowmonster {
                actualAnimationFrame += 1
                if actualAnimationFrame == 1 {
                    if let appleArray: AppleArray = ServiceLocator.shared.resolve(), let swallowedApple {
                        appleArray.remove(id: swallowedApple.id)
                    }
                }
                currentImage = swallowFrames[3 + actualAnimationFrame]
                if actualAnimationFrame == 4 {
                    actualAnimationFrame = 0
                    monsterType = .bluemonster
                    currentSpeed = GameConstants.Speed.monsterSpeed
                    
                }
            }
            else if monsterState == .moving || monsterState == .chasing || monsterState == .still || monsterState == .appearing {
                switch monsterDirection {
                case .left: currentImage = leftFrames[actualAnimationFrame]
                case .right: currentImage = rightFrames[actualAnimationFrame]
                case .up: currentImage = upFrames[actualAnimationFrame]
                case .down: currentImage = downFrames[actualAnimationFrame]
                }
                actualAnimationFrame += 1
                if actualAnimationFrame == 2 { actualAnimationFrame = 0 }
            }
        }
    }
    
    private func setImages() {
        for i in 0..<2 { walkRightFrames.append(getTile(name: "BlueMonsters", pos: i)!) }
        for i in 2..<4 { walkDownFrames.append(getTile(name: "BlueMonsters", pos: i)!) }
        for i in 4..<6 { walkLeftFrames.append(getTile(name: "BlueMonsters", pos: i)!) }
        for i in 6..<8 { walkUpFrames.append(getTile(name: "BlueMonsters", pos: i)!) }
        for i in 0..<16 { extraFrames.append(getTile(name: "ExtraMonsters", pos: i)!) }
        for i in 0..<8 { swallowFrames.append(getTile(name: "BlueSwallowMonster", pos: i)!)}
        
        if monsterType == .letter {
            leftFrames = [extraFrames[letter * 3 + 1],extraFrames[letter * 3 + 2]]
            rightFrames = leftFrames
            upFrames = leftFrames
            downFrames = leftFrames
            deadFrame = extraFrames[15]
        } else {
            leftFrames = walkLeftFrames
            rightFrames = walkRightFrames
            upFrames = walkUpFrames
            downFrames = walkDownFrames
            deadFrame = getTile(name: "BlueMonsters", pos: 8)!
        }
    }
}
