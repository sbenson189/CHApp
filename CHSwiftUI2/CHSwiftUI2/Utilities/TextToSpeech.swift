//
//  TextToSpeech.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 9/11/22.
//

import Foundation
import AVFoundation

public struct SpeakScore {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func announceScore(playerOneScore: Int, playerTwoScore: Int, playerOneName: String, playerTwoName: String) {
        
        var scoreAnnouncement: String { String("The Score is \(playerOneScore) to \(playerTwoScore), \(self.determinePlayerInLead(playerOneScore: playerOneScore, playerTwoScore: playerTwoScore, playerOneName: playerOneName, playerTwoName: playerTwoName))") }
        
        let utterance = AVSpeechUtterance(string: scoreAnnouncement)
        utterance.rate = 0.53
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.speechSynthesizer.speak(utterance)
    }
    
    func determinePlayerInLead(playerOneScore: Int, playerTwoScore: Int, playerOneName: String, playerTwoName: String) -> String {
        switch playerOneScore {
            case _ where playerOneScore > playerTwoScore:
                return "\(playerOneName) is in the leed" // Had to use "leed" instead of "lead". SS was saying the incorrect word.
            case _ where playerOneScore < playerTwoScore:
                return "\(playerTwoName) is in the leed"
            case _ where playerOneScore == playerTwoScore:
                return "The score is tied"
            default:
                return ""
        }
    }
    
}
