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
    static let notificationCherryScore = Notification.Name("NotificationCherryScore")
    static let notificationLoseLife = Notification.Name("NotificationLoseLife")
    static let notificationKillRedMonster = Notification.Name("NotificationKillRedMonster")
    static let notificationKillExtraMonster = Notification.Name("NotificationKillExtraMonster")
    static let notificationExtraLife = Notification.Name("NotificationExtraLife")
    static let notificationRemovePoints = Notification.Name("NotificationRemovePoints")
    static let notificationChaseMode = Notification.Name("NotificationChaseMode")
    static let notificationKillLetter = Notification.Name("NotificationKillLetter")
}

extension GameManager {
    
    func setNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextGame(notification:)), name: .notificationNewGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeApple(notification:)), name: .notificationRemoveApple, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addCherryScore(notification:)), name: .notificationCherryScore, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loseLife(notification:)), name: .notificationLoseLife, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeRedMonster(notification:)), name: .notificationKillRedMonster, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeExtraMonster(notification:)), name: .notificationKillExtraMonster, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addExtraLife(notification:)), name: .notificationExtraLife, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removePoints(notification:)), name: .notificationRemovePoints, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startChaseMode(notification:)), name: .notificationChaseMode, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeLetter(notification:)), name: .notificationKillLetter, object: nil)

        
        
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
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(3.0))
            checkNextLevel()
            
        }
    }
    
    @objc func loseLife(notification: Notification) {
        lives -= 1
        screenData.soundFX.backgroundStopAll()
        if lives == 0 {
            Task { @MainActor in
                endTime = Date()
                let difference = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
                gameTime += Int(difference)
                try? await Task.sleep(for: .seconds(GameConstants.Delay.gameOverDelay1))
                screenData.soundFX.gameOverSound()
                screenData.gameOver = true
                try? await Task.sleep(for: .seconds(GameConstants.Delay.gameOverDelay2))
                if hiScores.isNewHiScore(score: score,level: screenData.gameLevel, time: gameTime) {
                    hiScores.resetInput()
                    gameState = .highscore
                    screenData.soundFX.nameEntrySound()
                } else {
                    gameState = .intro
                }
            }
        } else {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(2.5))
                restartPlaying()
            }
        }
    }
    
    @objc func removeApple(notification: Notification) {
        if let id = notification.userInfo?["id"] as? UUID, let xPos = notification.userInfo?["xPos"] as? Int, let yPos = notification.userInfo?["yPos"] as? Int {
            appleArray.remove(id: id)
            
            let total = redMonsterArray.squashCount + extraMonsterArray.squashCount
            if total > 0 {
                appleHits(hits: total, xPos: xPos, yPos: yPos)
                redMonsterArray.squashCount = 0
                extraMonsterArray.squashCount = 0
            }
        }
    }
    private func appleHits(hits:Int,xPos:Int,yPos:Int){
        if hits == 1 {
            score += 1000
            points = Points(xPos: xPos, yPos: yPos, value: .onethousand)
        } else if hits == 2 {
            score += 2000
            points = Points(xPos: xPos, yPos: yPos, value: .twothousand)
        } else if hits == 3 {
            score += 4000
            points = Points(xPos: xPos, yPos: yPos, value: .fourthousand)
        } else if hits == 4 {
            score += 6000
            points = Points(xPos: xPos, yPos: yPos, value: .fourthousand)
        } else if hits >= 5 {
            score += 8000
            points = Points(xPos: xPos, yPos: yPos, value: .eightthousand)
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
        }
    }

    @objc func removeLetter(notification: Notification) {
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(GameConstants.Delay.extraLetterDelay))
            killLetter()
        }
    }

    @objc func removePoints(notification: Notification) {
        if points != nil {
            self.points = nil
        }
    }
    
    @objc func addCherryScore(notification: Notification) {
        if let count = notification.userInfo?["count"] as? Int {
            if count >= 0 { /// count of -1 means cherry eaten by digger
                score += GameConstants.Score.cherryPoints
                levelScore += GameConstants.Score.cherryPoints
                screenData.soundFX.cherrySound(count: count)
                if count == 8 {
                    score += GameConstants.Score.allCherryPoints
                    levelScore += GameConstants.Score.allCherryPoints
                }
            }
            cherryCount += 1
            if cherryCount == 40 {
                nextLevel(endType: .cherry)
            }
        }
    }
    
    @objc func startChaseMode(notification: Notification) {
        if !chaseMode {
            chaseMode = true
            screenData.soundFX.backgroundSoundStop()
            screenData.soundFX.backgroundFastSound()
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
