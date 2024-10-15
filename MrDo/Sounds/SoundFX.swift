//
//  SoundFX.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import Foundation
import AVFoundation

final class SoundFX {
    
    private var roundClearAudioPlayer: AVAudioPlayer?
    private var startAudioPlayer: AVAudioPlayer?
    private var backgroundAudioPlayer: AVAudioPlayer?
    private var cherry1AudioPlayer: AVAudioPlayer?
    private var cherry2AudioPlayer: AVAudioPlayer?
    private var cherry3AudioPlayer: AVAudioPlayer?
    private var cherry4AudioPlayer: AVAudioPlayer?
    private var cherry5AudioPlayer: AVAudioPlayer?
    private var cherry6AudioPlayer: AVAudioPlayer?
    private var cherry7AudioPlayer: AVAudioPlayer?
    private var cherry8AudioPlayer: AVAudioPlayer?
    private var appleDropAudioPlayer: AVAudioPlayer?
    private var appleBreakAudioPlayer: AVAudioPlayer?
    private var progressAudioPlayer: AVAudioPlayer?
    private var getAudioPlayer: AVAudioPlayer?
    private var barrelJumpAudioPlayer: AVAudioPlayer?
    private var walkingAudioPlayer: AVAudioPlayer?
    private var win1AudioPlayer: AVAudioPlayer?
    private var win2AudioPlayer: AVAudioPlayer?
    private var endLevelAudioPlayer: AVAudioPlayer?
    private var gameOverAudioPlayer: AVAudioPlayer?
    
    private lazy var roundClearurl = Bundle.main.url(forResource: "RoundClear", withExtension: "m4a")
    private lazy var starturl = Bundle.main.url(forResource: "Start", withExtension: "m4a")
    private lazy var backgroundurl = Bundle.main.url(forResource: "BGM", withExtension: "m4a")
    private lazy var cherry1url = Bundle.main.url(forResource: "Cherry1", withExtension: "m4a")
    private lazy var cherry2url = Bundle.main.url(forResource: "Cherry2", withExtension: "m4a")
    private lazy var cherry3url = Bundle.main.url(forResource: "Cherry3", withExtension: "m4a")
    private lazy var cherry4url = Bundle.main.url(forResource: "Cherry4", withExtension: "m4a")
    private lazy var cherry5url = Bundle.main.url(forResource: "Cherry5", withExtension: "m4a")
    private lazy var cherry6url = Bundle.main.url(forResource: "Cherry6", withExtension: "m4a")
    private lazy var cherry7url = Bundle.main.url(forResource: "Cherry7", withExtension: "m4a")
    private lazy var cherry8url = Bundle.main.url(forResource: "Cherry8", withExtension: "m4a")
    private lazy var appleBreakurl = Bundle.main.url(forResource: "AppleBreak", withExtension: "m4a")
    private lazy var appleDropurl = Bundle.main.url(forResource: "AppleDrop", withExtension: "m4a")
    private lazy var progressurl = Bundle.main.url(forResource: "Progress", withExtension: "m4a")
    private lazy var geturl = Bundle.main.url(forResource: "itemget", withExtension: "wav")
    private lazy var barrelJumpurl = Bundle.main.url(forResource: "jumpbar", withExtension: "wav")
    private lazy var walkingurl = Bundle.main.url(forResource: "walking", withExtension: "wav")
    private lazy var win1url = Bundle.main.url(forResource: "win1", withExtension: "wav")
    private lazy var win2url = Bundle.main.url(forResource: "win2", withExtension: "wav")
    private lazy var endLevelurl = Bundle.main.url(forResource: "DKEndLevel", withExtension: "m4a")
    private lazy var gameOverurl = Bundle.main.url(forResource: "DKGameOver", withExtension: "m4a")
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            roundClearAudioPlayer = try AVAudioPlayer(contentsOf: roundClearurl!, fileTypeHint: AVFileType.m4a.rawValue)
            startAudioPlayer = try AVAudioPlayer(contentsOf: starturl!, fileTypeHint: AVFileType.m4a.rawValue)
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: backgroundurl!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry1AudioPlayer = try AVAudioPlayer(contentsOf: cherry1url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry2AudioPlayer = try AVAudioPlayer(contentsOf: cherry2url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry3AudioPlayer = try AVAudioPlayer(contentsOf: cherry3url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry4AudioPlayer = try AVAudioPlayer(contentsOf: cherry4url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry5AudioPlayer = try AVAudioPlayer(contentsOf: cherry5url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry6AudioPlayer = try AVAudioPlayer(contentsOf: cherry6url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry7AudioPlayer = try AVAudioPlayer(contentsOf: cherry7url!, fileTypeHint: AVFileType.m4a.rawValue)
            cherry8AudioPlayer = try AVAudioPlayer(contentsOf: cherry8url!, fileTypeHint: AVFileType.m4a.rawValue)
            appleDropAudioPlayer = try AVAudioPlayer(contentsOf: appleDropurl!, fileTypeHint: AVFileType.m4a.rawValue)
            appleBreakAudioPlayer = try AVAudioPlayer(contentsOf: appleBreakurl!, fileTypeHint: AVFileType.m4a.rawValue)
            progressAudioPlayer = try AVAudioPlayer(contentsOf: progressurl!, fileTypeHint: AVFileType.m4a.rawValue)



            //            introLongAudioPlayer = try AVAudioPlayer(contentsOf: introLongurl!, fileTypeHint: AVFileType.wav.rawValue)
            //            introAudioPlayer = try AVAudioPlayer(contentsOf: introurl!, fileTypeHint: AVFileType.wav.rawValue)
            //            jumpAudioPlayer = try AVAudioPlayer(contentsOf: jumpurl!, fileTypeHint: AVFileType.wav.rawValue)
            //            getAudioPlayer = try AVAudioPlayer(contentsOf: geturl!, fileTypeHint: AVFileType.wav.rawValue)
            //            barrelJumpAudioPlayer = try AVAudioPlayer(contentsOf: barrelJumpurl!, fileTypeHint: AVFileType.wav.rawValue)
            //            walkingAudioPlayer = try AVAudioPlayer(contentsOf: walkingurl!, fileTypeHint: AVFileType.wav.rawValue)
            //            win1AudioPlayer = try AVAudioPlayer(contentsOf: win1url!, fileTypeHint: AVFileType.wav.rawValue)
            //            win2AudioPlayer = try AVAudioPlayer(contentsOf: win2url!, fileTypeHint: AVFileType.wav.rawValue)
            //            endLevelAudioPlayer = try AVAudioPlayer(contentsOf: endLevelurl!, fileTypeHint: AVFileType.m4a.rawValue)
            //            gameOverAudioPlayer = try AVAudioPlayer(contentsOf: endLevelurl!, fileTypeHint: AVFileType.m4a.rawValue)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func play(audioPlayer:AVAudioPlayer){
        audioPlayer.play()
    }
    
    
    func roundClear(){
        guard let roundClearAudioPlayer = roundClearAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: roundClearAudioPlayer)
    }
    
    func startSound(){
        guard let startAudioPlayer = startAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: startAudioPlayer)
    }

    func progressSound(){
        guard let progressAudioPlayer = progressAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: progressAudioPlayer)
    }
    
    func backgroundSound(){
        guard let backgroundAudioPlayer = backgroundAudioPlayer else { return }
        backgroundAudioPlayer.numberOfLoops = -1
        backgroundAudioPlayer.volume = 0.75
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: backgroundAudioPlayer)
    }
    
    func backgroundSoundStop(){
        guard let backgroundAudioPlayer = backgroundAudioPlayer else { return }
        backgroundAudioPlayer.stop()
    }
    
    func cherrySound(count:Int){
        switch count {
        case 1:
            cherrySound1()
        case 2:
            cherrySound2()
        case 3:
            cherrySound3()
        case 4:
            cherrySound4()
        case 5:
            cherrySound5()
        case 6:
            cherrySound6()
        case 7:
            cherrySound7()
        case 8:
            cherrySound8()
        default:
            cherrySound1()
        }
    }
    
    func appleDropSound(){
        guard let appleDropAudioPlayer = appleDropAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: appleDropAudioPlayer)
    }

    func appleBreakSound(){
        guard let appleBreakAudioPlayer = appleBreakAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: appleBreakAudioPlayer)
    }

    func appleDropSoundStop(){
        guard let appleDropAudioPlayer = appleDropAudioPlayer else { return }
        appleDropAudioPlayer.stop()
    }

    func cherrySound1(){
        guard let cherry1AudioPlayer = cherry1AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry1AudioPlayer)
    }
    func cherrySound2(){
        guard let cherry2AudioPlayer = cherry2AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry2AudioPlayer)
    }
    func cherrySound3(){
        guard let cherry3AudioPlayer = cherry3AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry3AudioPlayer)
    }
    func cherrySound4(){
        guard let cherry4AudioPlayer = cherry4AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry4AudioPlayer)
    }
    func cherrySound5(){
        guard let cherry5AudioPlayer = cherry5AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry5AudioPlayer)
    }
    func cherrySound6(){
        guard let cherry6AudioPlayer = cherry6AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry6AudioPlayer)
    }
    func cherrySound7(){
        guard let cherry7AudioPlayer = cherry7AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry7AudioPlayer)
    }
    func cherrySound8(){
        guard let cherry8AudioPlayer = cherry8AudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: cherry8AudioPlayer)
    }

    
    
    //
    //
    //
    //    func gameOverSound(){
    //        guard let gameOverAudioPlayer = gameOverAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: gameOverAudioPlayer)
    //    }
    //
    //    func endLevelSound(){
    //        guard let endLevelAudioPlayer = endLevelAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: endLevelAudioPlayer)
    //    }
    //
    //
    //    func howHighSound() {
    //        guard let howHighAudioPlayer = howHighAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: howHighAudioPlayer)
    //    }
    //    func introLongSound() {
    //        guard let introLongAudioPlayer = introLongAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: introLongAudioPlayer)
    //    }
    //    func introSound() {
    //        guard let introAudioPlayer = introAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: introAudioPlayer)
    //    }
    //
    //    func jumpSound() {
    //        guard let jumpAudioPlayer = jumpAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: jumpAudioPlayer)
    //    }
    //
    //    func getItemSound()
    //    {
    //        guard let getAudioPlayer = getAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: getAudioPlayer)
    //    }
    //    func barrelJumpSound()
    //    {
    //        guard let barrelJumpAudioPlayer = barrelJumpAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: barrelJumpAudioPlayer)
    //    }
    //
    //    func walkingSound()
    //    {
    //        guard let walkingAudioPlayer = walkingAudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: walkingAudioPlayer)
    //    }
    //
    //    func win1Sound()
    //    {
    //        guard let win1AudioPlayer = win1AudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: win1AudioPlayer)
    //    }
    //
    //    func win2Sound()
    //    {
    //        guard let win2AudioPlayer = win2AudioPlayer else { return }
    //        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: win2AudioPlayer)
    //    }
}
