//
//  GameConstants.swift
//  MrDo
//
//  Created by Jonathan French on 29.10.24.
//

import CoreGraphics

public enum GameState {
    case intro,playing,ended,highscore,levelend,progress,progress10,extralife
}

public enum JoyPad {
    case left,right,up,down,stop
}

public enum LevelEndType {
    case cherry,redmonster,extramonster
}

public enum GameConstants {
    
    public enum Game {
        public static let extraLifeLetters = 5
        public static let initialLives = 3
        public static let screenWidth = 12
        public static let screenHeight = 13
    }
    
    public enum Speed {
        public static let tileSteps = 8.0
        public static let doSpeed = 2
        public static let ballSpeed = 2
        public static let monsterSpeed = 4
        public static let digSpeed = 6
        public static let appleSpeed = 1
    }
    
    public enum Size {
#if os(iOS)
        public static let doSize = CGSize(width: 30, height: 30)
        public static let appleSize = CGSize(width: 28, height: 28)
        public static let ballSize = CGSize(width: 12, height: 12)
        public static let redMonsterSize = CGSize(width: 28, height: 28)
        public static let extraMonsterSize = CGSize(width: 28, height: 28)
        public static let pointsSize = CGSize(width: 40, height: 24)
        public static let typeSize = 30.0
        public static let extraSpacing = 8.0
        public static let wonderSize = CGSize(width: 0, height: 236)
        public static let lifeSize = CGSize(width: 24, height: 24)
        public static let centerSize = CGSize(width: 32, height: 32)

#elseif os(tvOS)
        public static let doSize = CGSize(width: 64, height: 64)
        public static let appleSize = CGSize(width: 64, height: 64)
        public static let ballSize = CGSize(width: 24, height: 24)
        public static let redMonsterSize = CGSize(width: 52, height: 52)
        public static let extraMonsterSize = CGSize(width: 52, height: 52)
        public static let pointsSize = CGSize(width: 80, height: 48)
        public static let typeSize = 60.0
        public static let extraSpacing = 16.0
        public static let wonderSize = CGSize(width: 0, height: 586)
        public static let lifeSize = CGSize(width: 48, height: 48)
        public static let centerSize = CGSize(width: 64, height: 64)
#endif
    }
    
    public enum Text {
#if os(iOS)
        public static let startText = "PRESS FIRE TO START"
        public static let starttextSize:CGFloat = 14
        public static let copyTextSize:CGFloat = 12
        public static let titleTextSize:CGFloat = 18
        public static let extraTextSize:CGFloat = 18
        public static let highScoreTextSize:CGFloat = 24
        public static let subTitleTextSize:CGFloat = 12
        public static let scoreTextSize:CGFloat = 16
        public static let letterTextSize:CGFloat = 30

#elseif os(tvOS)
        public static let startText = "PRESS A TO START"
        public static let starttextSize:CGFloat = 24
        public static let copyTextSize:CGFloat = 28
        public static let titleTextSize:CGFloat = 28
        public static let extraTextSize:CGFloat = 36
        public static let highScoreTextSize:CGFloat = 28
        public static let subTitleTextSize:CGFloat = 12
        public static let scoreTextSize:CGFloat = 16
        public static let letterTextSize:CGFloat = 60
#endif
    }
    
    public enum Delay {
        public static let levelEndDelay = 3.5
        public static let monsterSpawnDelay = 2.3
        public static let extraMonsterSpawnDelay = 1.5
        public static let nextLevelDelay = 3.0
        public static let showNextLevelDelay = 10.0
        public static let progress10Delay = 10.0
        public static let gameOverDelay1 = 1.5
        public static let gameOverDelay2 = 5.0
        public static let progressPauseDelay = 1.0
        public static let monsterKillDelay = 1.0
        public static let extraLetterDelay = 1.5
        public static let removePointsDelay = 1.5
        public static let extraLifeDelay1 = 2.0
        public static let extraLifeDelay2 = 1.0
        public static let returnBallDelay = 2.0
        public static let extraHeaderDelay = 2.0
    }
    
    public enum Score {
        public static let cherryPoints = 100
        public static let allCherryPoints = 500
        public static let monsterPoints = 500
        public static let extraLifePoints = 10000
    }
    
    public enum Timing {
        public static let frameRate = 1.0 / 60.0
        public static let animationFrameRate = 0.1
    }
    
    public enum Animation {
        public static let appleAnimation = 0.2
        public static let appleBreakAnimation = 0.1
        public static let extraFlashRate = 0.5
    }
    
    public enum Sound {
        public static let effectsVolume:Float = 1.0
        public static let backgroundVolume:Float = 1.0
        public static let musicVolume:Float = 1.0
    }
}




