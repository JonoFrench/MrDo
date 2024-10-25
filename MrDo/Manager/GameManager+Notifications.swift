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
    static let notificationLoseLife = Notification.Name("NotificationLoseLife")
    static let notificationKillRedMonster = Notification.Name("NotificationKillRedMonster")
    static let notificationKillExtraMonster = Notification.Name("NotificationKillExtraMonster")
    static let notificationExtraLife = Notification.Name("NotificationExtraLife")
}

extension GameManager {
    
    func notificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextGame(notification:)), name: .notificationNewGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeApple(notification:)), name: .notificationRemoveApple, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addScore(notification:)), name: .notificationAddScore, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loseLife(notification:)), name: .notificationLoseLife, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeRedMonster(notification:)), name: .notificationKillRedMonster, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeExtraMonster(notification:)), name: .notificationKillExtraMonster, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addExtraLife(notification:)), name: .notificationExtraLife, object: nil)

        
        
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
    
    @objc func addExtraLife(notification: Notification) {
        lives += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            checkNextLevel()
        }
    }
    
    @objc func loseLife(notification: Notification) {
        lives -= 1
        gameScreen.soundFX.backgroundStopAll()
        if lives == 0 {
            endTime = Date()
            let difference = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            gameTime += Int(difference)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                gameScreen.soundFX.gameOverSound()
                gameScreen.gameOver = true
                self.objectWillChange.send()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                    if hiScores.isNewHiScore(score: score,level: gameScreen.level, time: gameTime) {
                        hiScores.resetInput()
                        gameState = .highscore
                        gameScreen.soundFX.nameEntrySound()
                    } else {
                        gameState = .intro
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                restartPlaying()
            }

        }
    }

    @objc func removeApple(notification: Notification) {
        if let id = notification.userInfo?["id"] as? UUID {
            appleArray.remove(id: id)
        }
    }
    @objc func removeRedMonster(notification: Notification) {
        if let id = notification.userInfo?["id"] as? UUID {
            redMonsterArray.remove(id: id)
            if redMonsterArray.killCount == 6 {
                nextLevel(endType: .redmonster)
            }
        }
    }

    @objc func removeExtraMonster(notification: Notification) {
        if let id = notification.userInfo?["id"] as? UUID {
            extraMonsterArray.remove(id: id)
//            if redMonsterArray.killCount == 6 {
//                nextLevel(endType: .redmonster)
//            }
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
                    nextLevel(endType: .cherry)
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
