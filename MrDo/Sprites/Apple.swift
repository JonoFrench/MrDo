//
//  Apple.swift
//  MrDo
//
//  Created by Jonathan French on 18.09.24.
//

import Foundation
import SwiftUI
import UIKit


final class AppleArray: ObservableObject {
    @Published var apples: [Apple] = []

    func move(){
        for apple in apples where apple.appleState == .falling {
            apple.move()
            self.objectWillChange.send()
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
    
    func checkDrop(){
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            for apple in apples where apple.appleState == .sitting {
                if screenData.levelData.tileArray[apple.yPos+1][apple.xPos] == .hz {
                    apple.dislodge()
                }
            }
        }
    }

}
enum AppleState {
    case sitting,dislodged,falling,breaking
}

final class Apple:SwiftUISprite,Moveable, ObservableObject {
    static var speed: Int = 1
    
    @Published
    var appleState:AppleState = .sitting
    var dropLevel = 0
    var moveCounter = 0
    init(xPos: Int, yPos:Int) {
        
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 30, height:  30))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 64, height:  64))
#endif
        currentImage = getTile(name: "Apple", pos: 1)!
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
                    appleState = .sitting
                    yPos += 1
                }
            }
        }
    }
    
    func dislodge() {
        appleState = .dislodged
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            currentImage = getTile(name: "Apple", pos: 2)!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                currentImage = getTile(name: "Apple", pos: 0)!
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    currentImage = getTile(name: "Apple", pos: 1)!
                    appleState = .falling
                }
            }
        }
    }
    
    
}
