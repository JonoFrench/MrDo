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

    func move(){
        for apple in apples where apple.appleState == .falling {
            apple.move()
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

final class Apple:SwiftUISprite,Moveable {
    static var speed: Int = 1
    
    @Published
    var appleState:AppleState = .sitting
    var dropLevel = 0
    var moveCounter = 0
    @Published
    var leftImage:UIImage = UIImage()
    @Published
    var rightImage:UIImage = UIImage()
    var appleFrames: [UIImage] = []
    var isPushed = false
    init(xPos: Int, yPos:Int) {
        
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 30, height:  30))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 64, height:  64))
#endif
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
                print("Apple falling moveCounter \(moveCounter) pos \(position.y)")
                if moveCounter == 8 {
                    moveCounter = 0
                    dropLevel += 1
                    let checkAsset = screenData.levelData.tileArray[yPos+1][xPos]
                    print("Apple YPos checkAsset \(checkAsset)")
                    if checkAsset == .rb || checkAsset == .lb || checkAsset == .br || checkAsset == .bl || checkAsset == .ch || checkAsset == .fu || checkAsset == .hz || checkAsset == .rl || checkAsset == .rr || yPos == screenData.screenDimensionY {
                        print("Apple fall checkAsset \(checkAsset) dropLevel \(dropLevel)")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            currentImage = appleFrames[2]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                currentImage = appleFrames[0]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    currentImage = appleFrames[1]
                    appleState = .falling
                    if let screenData: ScreenData = ServiceLocator.shared.resolve() {
                        screenData.soundFX.appleDropSound()
                    }
                }
            }
        }
    }
    
    func breakApple() {
        appleState = .breaking
        leftImage = getTile(name: "AppleEnd", pos: 0)!
        rightImage = getTile(name: "AppleEnd", pos: 1)!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            if let screenData: ScreenData = ServiceLocator.shared.resolve() {
                screenData.soundFX.appleDropSoundStop()
                screenData.soundFX.appleBreakSound()
            }
            leftImage = getTile(name: "AppleEnd", pos: 2)!
            rightImage = getTile(name: "AppleEnd", pos: 3)!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                leftImage = getTile(name: "AppleEnd", pos: 4)!
                rightImage = getTile(name: "AppleEnd", pos: 5)!
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    let appleID:[String: UUID] = ["id": self.id]
                    NotificationCenter.default.post(name: .notificationRemoveApple, object: nil, userInfo: appleID)
                }
            }
        }
    }
    
}
