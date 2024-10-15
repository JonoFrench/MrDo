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
    static let notificationAddScore = Notification.Name("NotificationAddScore")

}

extension GameManager {
    
    func notificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextGame(notification:)), name: .notificationNewGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeApple(notification:)), name: .notificationRemoveApple, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.addScore(notification:)), name: .notificationAddScore, object: nil)

        
        
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

    @objc func addScore(notification: Notification) {
        if let value = notification.userInfo?["score"] as? Int,let count = notification.userInfo?["count"] as? Int {
            score += value
            levelScore += value
            if value == 50 {
                gameScreen.soundFX.cherrySound(count: count)
                if count == 8 {
                    score += 500
                    levelScore += 500
                }
                cherryCount += 1
                if cherryCount == 40 {
                    nextLevel()
                }
            }
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
