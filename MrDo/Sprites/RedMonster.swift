//
//  RedMonster.swift
//  MrDo
//
//  Created by Jonathan French on 17.10.24.
//

import Foundation
import SwiftUI

final class RedMonsterArray: ObservableObject {
    @Published var monsters: [RedMonster] = []
    var monsterCount = 0
    var killCount = 0
    
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
    
    func add(xPos:Int,yPos:Int) {
        let monster = RedMonster(xPos: xPos, yPos:yPos)
        monsters.append(monster)
        monsterCount += 1
    }
    
}

final class RedMonster:Monster,Moveable,Animatable {
    static var animateFrames: Int = 0
    static var speed: Int = GameConstants.monsterSpeed
    
    private var walkRightFrames: [UIImage] = []
    private var walkLeftFrames: [UIImage] = []
    private var walkUpFrames: [UIImage] = []
    private var walkDownFrames: [UIImage] = []
    
    private var chaseRightFrames: [UIImage] = []
    private var chaseLeftFrames: [UIImage] = []
    private var chaseUpFrames: [UIImage] = []
    private var chaseDownFrames: [UIImage] = []
    
    private var stripeRightFrames: [UIImage] = []
    private var stripeLeftFrames: [UIImage] = []
    private var stripeUpFrames: [UIImage] = []
    private var stripeDownFrames: [UIImage] = []
        
    private var appearCount = 0
    
    private var actualAnimationFrame = 0
    private var increaseSpeedCounter = 0
    
    init(xPos: Int, yPos: Int) {
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 28, height:  28))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 52, height:  52))
#endif
        setImages()
        currentImage = walkRightFrames[0]
        actualAnimationFrame = 0
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            moveDistance = resolvedInstance.assetDimensionStep
        }
        gridOffsetY = 0
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
            NotificationCenter.default.post(name: .notificationKillRedMonster, object: nil, userInfo: monsterID)
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
    
    func move() {
        guard monsterState != .appearing && monsterState != .dead && monsterState != .still else { return }
        if monsterState == .falling {
            fall()
            return
        } else {
            monsterMove()
        }
    }
    
    func animate() {
        guard monsterState != .dead else { return }
        currentAnimationFrame += 1
        if currentAnimationFrame == 8 {
            currentAnimationFrame = 0
            if monsterState == .appearing {
                currentImage = appearCount % 2 == 0 ? walkRightFrames[0] : blankFrame
                appearCount += 1
                if appearCount == 13 {
                    monsterState = .moving
                    monsterDirection = nextDirection()
                }
            } else if monsterState == .moving || monsterState == .chasing || monsterState == .still {
                switch monsterDirection {
                case .left:
                    currentImage = leftFrames[actualAnimationFrame]
                case .right:
                    currentImage = rightFrames[actualAnimationFrame]
                case .up:
                    currentImage = upFrames[actualAnimationFrame]
                case .down:
                    currentImage = downFrames[actualAnimationFrame]
                }
                actualAnimationFrame += 1
                if actualAnimationFrame == 3 {
                    actualAnimationFrame = 0
                }
                
            }
        }
    }
    
    private func setImages() {
        for i in 0..<3 {
            walkRightFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 3..<6 {
            walkDownFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 6..<9 {
            walkLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 9..<12 {
            walkUpFrames.append(getTile(name: "RedMonsters", pos: i,y:0)!)
        }
        for i in 0..<3 {
            chaseRightFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        for i in 3..<6 {
            chaseDownFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        for i in 6..<9 {
            chaseLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        for i in 9..<12 {
            chaseUpFrames.append(getTile(name: "RedMonsters", pos: i,y:1)!)
        }
        for i in 0..<3 {
            stripeRightFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }
        for i in 3..<6 {
            stripeDownFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }
        for i in 6..<9 {
            stripeLeftFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }
        for i in 9..<12 {
            stripeUpFrames.append(getTile(name: "RedMonsters", pos: i,y:2)!)
        }

        deadFrame = getTile(name: "RedMonsters", pos: 12,y:0)!
        blankFrame = getTile(name: "RedMonsters", pos: 12,y:1)!
        
        leftFrames = walkLeftFrames
        rightFrames = walkRightFrames
        upFrames = walkUpFrames
        downFrames = walkDownFrames
        
//        leftFrames = stripeLeftFrames
//        rightFrames = stripeRightFrames
//        upFrames = stripeUpFrames
//        downFrames = stripeDownFrames

    }
    
    private func chaseMode(){
        leftFrames = chaseLeftFrames
        rightFrames = chaseRightFrames
        upFrames = chaseUpFrames
        downFrames = chaseDownFrames
        monsterState = .chasing
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            screenData.soundFX.backgroundSoundStop()
            screenData.soundFX.backgroundFastSound()
        }
    }
}
