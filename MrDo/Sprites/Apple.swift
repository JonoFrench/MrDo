//
//  Apple.swift
//  MrDo
//
//  Created by Jonathan French on 18.09.24.
//

import Foundation
import SwiftUI
import UIKit


enum AppleState {
    case sitting,dislodged,falling,breaking
}

final class AppleArray: ObservableObject {
    @Published var apples: [Apple] = []
    
    func move() {
        for apple in apples where apple.appleState == .falling {
            apple.move()
            if let doInstance: MrDo = ServiceLocator.shared.resolve() {
                /// Has the apple fallen on MrDo?
                if apple.xPos == doInstance.xPos && apple.yPos == doInstance.yPos {
                    doInstance.moveCounter = 7
                    doInstance.doState = .falling
                }
            }
            /// Has the apple landed on any Red Monsters?
            if let monsterInstance:RedMonsterArray = ServiceLocator.shared.resolve() {
                for monster in monsterInstance.monsters where monster.monsterState != .falling && monster.monsterState != .appearing {
                    if apple.xPos == monster.xPos && apple.yPos == monster.yPos {
                        monster.squash()
                        monster.position = apple.position
                        monster.position.y -= apple.frameSize.height
                        monsterInstance.squashCount += 1
                    }
                }
            }
            /// Has the apple landed on any Blue or Extra Monsters?
            if let monsterInstance:ExtraMonsterArray = ServiceLocator.shared.resolve() {
                for monster in monsterInstance.monsters where monster.monsterState != .falling {
                    if apple.xPos == monster.xPos && apple.yPos == monster.yPos {
                        monster.squash()
                        monster.position = apple.position
                        monster.position.y -= apple.frameSize.height
                        monsterInstance.squashCount += 1
                        if monster.monsterType == .letter {
                            NotificationCenter.default.post(name: .notificationKillLetter, object: nil, userInfo: nil)
                        }
                    }
                }
            }
        }
    }
        
    func remove(id:UUID) {
        if let index = apples.firstIndex(where: {$0.id == id}) {
            apples.remove(at: index)
        }
    }
    
    func add(xPos:Int,yPos:Int) {
        let apple = Apple(xPos: xPos, yPos:yPos)
        apples.append(apple)
    }
    
    func checkDrop(doXpos:Int,doYpos:Int){
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            for apple in apples where apple.appleState == .sitting {
                if apple.yPos < screenData.screenDimensionY - 1 {
                    let checkAsset = screenData.levelData.tileArray[apple.yPos+1][apple.xPos]
                    if !(checkAsset == .fu || checkAsset == .ch) && (apple.yPos+1 != doYpos || apple.xPos != doXpos) {
                        print("Apple dislodge checkAsset \(checkAsset)")
                        if !apple.isPushed {
                            apple.dislodge()
                        } else {
                            apple.appleState = .falling
                        }
                    }
                }
            }
        }
    }
}

final class Apple:SwiftUISprite,Moveable {
    static var speed: Int = GameConstants.Speed.appleSpeed
    @Published
    var appleState:AppleState = .sitting
    @Published
    var leftImage:UIImage = UIImage()
    @Published
    var rightImage:UIImage = UIImage()
    var isPushed = false
    private var appleFrames: [UIImage] = []
    private var dropLevel = 0

    init(xPos: Int, yPos:Int) {
        super.init(xPos: xPos, yPos: yPos, frameSize: GameConstants.Size.appleSize)
        setImages()
        currentImage = appleFrames[1]
        isShowing = true
    }
    
    func setImages() {
        for i in 0..<3 {
            appleFrames.append(getTile(name: "Apple", pos: i)!)
        }
    }
    
    func move() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            speedCounter += 1
            if speedCounter == Apple.speed {
                speedCounter = 0
                moveCounter += 1
                position.y += screenData.assetDimensionStep
                if moveCounter == 8 {
                    moveCounter = 0
                    dropLevel += 1
                    var checkAsset:TileType = .lb
                    if yPos < screenData.screenDimensionY-1 {
                        checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
                    }
                    if checkAsset == .rb || checkAsset == .lb || checkAsset == .br || checkAsset == .bl || checkAsset == .ch || checkAsset == .fu || checkAsset == .hz || checkAsset == .rl || checkAsset == .rr {
                        if dropLevel > 1 {
                            breakApple()
                        } else {
                            dropLevel = 0
                            appleState = .sitting
                            screenData.soundFX.appleDropSoundStop()
                        }
                    }
                    yPos += 1
                }
            }
        }
    }
    
    func dislodge() {
        appleState = .dislodged
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(GameConstants.Animation.appleAnimation))
                currentImage = appleFrames[2]
                try? await Task.sleep(for: .seconds(GameConstants.Animation.appleAnimation))
                currentImage = appleFrames[0]
                try? await Task.sleep(for: .seconds(GameConstants.Animation.appleAnimation))
                currentImage = appleFrames[1]
                appleState = .falling
                screenData.soundFX.appleDropSound()
            }
        }
    }
    
    func breakApple() {
        appleState = .breaking
        leftImage = getTile(name: "AppleEnd", pos: 0)!
        rightImage = getTile(name: "AppleEnd", pos: 1)!
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(GameConstants.Animation.appleBreakAnimation))
                screenData.soundFX.appleDropSoundStop()
                screenData.soundFX.appleBreakSound()
                leftImage = getTile(name: "AppleEnd", pos: 2)!
                rightImage = getTile(name: "AppleEnd", pos: 3)!
                try? await Task.sleep(for: .seconds(GameConstants.Animation.appleBreakAnimation))
                leftImage = getTile(name: "AppleEnd", pos: 4)!
                rightImage = getTile(name: "AppleEnd", pos: 5)!
                try? await Task.sleep(for: .seconds(GameConstants.Animation.appleAnimation))
                let appleID: [String: Any] = [
                    "id": self.id,
                    "xPos": self.xPos,
                    "yPos":self.yPos]
                NotificationCenter.default.post(name: .notificationRemoveApple, object: nil, userInfo: appleID)
            }
        }
    }
    
}
