//
//  GameManager+Notifications.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import Foundation
import SwiftUI
#if os(tvOS)
import GameController
#endif
extension Notification.Name {
    static let notificationNewGame = Notification.Name("NotificationNewGame")
    static let notificationRemoveApple = Notification.Name("NotificationRemoveApple")

}

extension GameManager {
    
    func notificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextGame(notification:)), name: .notificationNewGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeApple(notification:)), name: .notificationRemoveApple, object: nil)

 
        
        
#if os(tvOS)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDidConnect),
            name: .GCControllerDidConnect,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDidDisconnect),
            name: .GCControllerDidDisconnect,
            object: nil
        )
#endif
        
    }
    
    @objc func nextGame(notification: Notification) {
        gameState = .intro
    }
    
    @objc func removeApple(notification: Notification) {
        if let id = notification.userInfo?["id"] as? UUID {
            appleArray.remove(id: id)
        }
    }

    
#if os(tvOS)
    @objc func controllerDidConnect(notification: Notification) {
        if let controller = notification.object as? GCController {
            // Set up your controller
            setupController(controller)
        }
    }

    @objc func controllerDidDisconnect(notification: Notification) {
        // Handle controller disconnection if needed
    }
    #endif
    
}
