//
//  Points.swift
//  MrDo
//
//  Created by Jonathan French on 27.10.24.
//

import Foundation
import SwiftUI

enum PointValues {
    case fivehundred,onethousand,twothousand,fourthousand,eightthousand
}

final class Points: SwiftUISprite {

    init(xPos: Int, yPos: Int,value:PointValues) {
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 40, height:  24))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 80, height:  48))
#endif
        setPoints(value: value)
        ///Show the points then remove after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            NotificationCenter.default.post(name: .notificationRemovePoints, object: nil, userInfo: nil)
        }
    }
    
    func setPoints(value:PointValues) {
        switch value {
        case .fivehundred:
            currentFrame = ImageResource(name: "Points500", bundle: .main)
        case .onethousand:
            currentFrame = ImageResource(name: "Points1000", bundle: .main)
        case .twothousand:
            currentFrame = ImageResource(name: "Points2000", bundle: .main)
        case .fourthousand:
            currentFrame = ImageResource(name: "Points4000", bundle: .main)
        case .eightthousand:
            currentFrame = ImageResource(name: "Points8000", bundle: .main)
        }
    }
    
    
}
