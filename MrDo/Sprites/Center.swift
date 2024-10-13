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
    
    init(xPos: Int, yPos:Int) {
        
#if os(iOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 32, height:  32))
#elseif os(tvOS)
        super.init(xPos: xPos, yPos: yPos, frameSize: CGSize(width: 64, height:  64))
#endif
        if let resolvedInstance: ScreenData = ServiceLocator.shared.resolve() {
            //frameSize = CGSize(width: resolvedInstance.assetDimension, height: resolvedInstance.assetDimension)
        }
        currentFrame = ImageResource(name: "CenterMonster", bundle: .main)
    }
    
    
}
