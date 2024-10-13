//
//  SwiftUISprite.swift
//  DonkeyKong
//
//  Created by Jonathan French on 27.08.24.
//

import Foundation
import SwiftUI

protocol Animatable {
    static var animateFrames: Int { get } 
    var animateCounter:Int {get set}

    func animate()
}

protocol Moveable {
    static var speed: Int { get }
    var speedCounter:Int {get set}
    
    func move()
}

class SwiftUISprite:ObservableObject {
    var id = UUID()
    var xPos = 0
    var yPos = 0
    var currentAnimationFrame = 0
    @Published
    var position = CGPoint()
    @Published
    var isShowing = false
    var frameSize: CGSize = CGSize()
    @Published
    var currentFrame:ImageResource = ImageResource(name: "", bundle: .main)
    @Published
    var currentImage:UIImage = UIImage()

    var gridOffsetX = 0
    var gridOffsetY = 0
    var moveDistance = 0.0
    var speedCounter: Int = 0
    var animateCounter: Int = 0

    init(xPos: Int, yPos: Int, frameSize: CGSize) {
        self.xPos = xPos
        self.yPos = yPos
        self.frameSize = frameSize
        position = calcPosition()
    }
    
    func calcPosition() -> CGPoint {
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            let pos = CGPoint(x: Double(xPos) * resolvedInstance.assetDimension + (resolvedInstance.assetDimension / 2),y:Double(yPos) * resolvedInstance.assetDimension + (resolvedInstance.assetDimension / 2))
            return pos
        }
        return CGPoint()
    }
    
    func setPosition(xPos:Int, yPos:Int) {
        self.xPos = xPos
        self.yPos = yPos
        position = calcPosition()
    }

    func getTile(name:String,pos:Int) -> UIImage? {
        guard let image = UIImage(named: name) else { return nil }
        let rect = CGRect(x: pos * 16, y: 0, width: 16, height: 16)
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    
//        .position(x:Double(x) * gameScreen.assetDimension + (gameScreen.assetDimension / 2),y: Double(y) * gameScreen.assetDimension + (gameScreen.assetDimension / 2))

    func generateParabolicPoints(from pointA: CGPoint, to pointB: CGPoint, steps: Int = 9, angleInDegrees: CGFloat = 10) -> [CGPoint] {
        var points: [CGPoint] = []
        
        // Horizontal distance between pointA and pointB
        let dx = pointB.x - pointA.x
        
        // Height of the parabola (peak) based on 10 degrees
        let peakHeight = (dx / 2) * tan(angleInDegrees * .pi / 180)
        
        // Midpoint (vertex of the parabola)
        let midPointX = (pointA.x + pointB.x) / 2
        let vertex = CGPoint(x: midPointX, y: pointA.y - peakHeight)
        
        // Parabola equation: y = a(x - h)^2 + k
        // We need to solve for 'a' given points A and vertex
        let a = (pointA.y - vertex.y) / pow(pointA.x - vertex.x, 2)
        
        // Generate points along the parabola
        for i in 0...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let x = pointA.x + t * (pointB.x - pointA.x)
            let y = a * pow(x - vertex.x, 2) + vertex.y
            points.append(CGPoint(x: x, y: y))
        }        
        return points
    }
    
    func doubleFrameSize(frame:CGSize) -> CGSize {
        return CGSize(width: frame.width * 2, height: frame.height * 2)
    }
}
