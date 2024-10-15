//
//  Progress.swift
//  MrDo
//
//  Created by Jonathan French on 15.10.24.
//

import Foundation
import SwiftUI

final class Progress: ObservableObject, Moveable {
    static var speed: Int = 2
    var speedCounter: Int = 0
    var currentAnimationFrame: Int = 0

    @Published
    var charFrame:ImageResource = ImageResource(name: "ProgressCharL", bundle: .main)
    var appleFrame:ImageResource = ImageResource(name: "ProgressApple", bundle: .main)
    @Published
    var doFrame:ImageResource = ImageResource(name: "ProgressDo1", bundle: .main)
    @Published
    var monsterFrame:ImageResource = ImageResource(name: "ProgressMonster1", bundle: .main)
    @Published
    var charPosition = CGPoint()
    @Published
    var applePosition = CGPoint()
    @Published
    var monsterPosition = CGPoint()
    @Published
    var doPosition = CGPoint()
#if os(iOS)
    var frameSize: CGSize = CGSize(width: 80, height: 80)
    var doFrameSize : CGSize = CGSize(width: 80, height: 88)
    var speed = 8.0
#elseif os(tvOS)
    var frameSize: CGSize = CGSize(width: 160, height: 160)
    var doFrameSize : CGSize = CGSize(width: 160, height: 172)
    var speed = 16.0
#endif
    var animateFrame = false
    var pauseFrame = false
    var width = 0
    var halfWay = 0

    init() {
        if let screenData: ScreenData = ServiceLocator.shared.resolve() {
            width = Int(screenData.gameSize.width)
            halfWay = roundToClosestMultipleNumber(width / 2,Int(speed))
            let height = screenData.gameSize.height / 3
            charPosition = CGPoint(x: 0 - frameSize.width, y: height)
            monsterPosition = CGPoint(x: -(frameSize.width / 2) - frameSize.width - CGFloat(halfWay), y: height)
            applePosition = CGPoint(x: -(frameSize.width) - (frameSize.width * 2) - CGFloat(halfWay) , y: height)
            doPosition = CGPoint(x: -(frameSize.width) - (frameSize.width * 3) - CGFloat(halfWay), y: height)
            print("Progress Width \(halfWay)")
        }
    }
    
    func roundToClosestMultipleNumber(_ numberOne: Int, _ numberTwo: Int) -> Int {
        var result: Int = numberOne
        
        if numberOne % numberTwo != 0 {
            if numberOne < numberTwo {
                result = numberTwo
            } else {
                result = (numberOne / numberTwo + 1) * numberTwo
            }
        }
        return result
    }
    
    func move() {
        speedCounter += 1
        if speedCounter == 3 {
            speedCounter = 0
            if !pauseFrame {
                charPosition.x += speed
                monsterPosition.x += speed
                applePosition.x += speed
                doPosition.x += speed
            }
            
            if Int(charPosition.x) == halfWay {
                pauseFrame = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    pauseFrame = false
                }
            }
            animate()
        }
    }
    
    func animate() {
        currentAnimationFrame += 1
        if currentAnimationFrame == 3 {
            currentAnimationFrame = 0
            charFrame = animateFrame ? ImageResource(name: "ProgressCharL", bundle: .main) : ImageResource(name: "ProgressCharR", bundle: .main)
            monsterFrame = animateFrame ? ImageResource(name: "ProgressMonster1", bundle: .main) : ImageResource(name: "ProgressMonster2", bundle: .main)
            doFrame = animateFrame ? ImageResource(name: "ProgressDo1", bundle: .main) : ImageResource(name: "ProgressDo2", bundle: .main)
            animateFrame = !animateFrame
        }

    }
    
    
}
