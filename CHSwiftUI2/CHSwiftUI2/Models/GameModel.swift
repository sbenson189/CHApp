//
//  GameModel.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 8/23/22.
//

import Foundation
import AVFoundation
import UIKit

struct Game {
    
    var playerOne: Player
    var playerTwo: Player

    var playerOneGameScore: Int
    var playerOneRoundScore: Int
    
    var playerTwoGameScore: Int
    var playerTwoRoundScore: Int
    
    var playerOneInCount: Int
    var playerOneOnCount: Int
    
    var playerTwoInCount: Int
    var playerTwoOnCount: Int
    
    var showAlert: Bool
    
    var gameRules: Rules = .tournament
    
    var playerOneWins: Bool = false
    var playerTwoWins: Bool = false
    
    var speechSynthesizer: SpeakScore?
    
    mutating func resetRound() {
        playerOneRoundScore = 0
        playerTwoRoundScore = 0
        
        playerOneInCount = 0
        playerOneOnCount = 0
        
        playerTwoInCount = 0
        playerTwoOnCount = 0
    }
    
    // MARK: Used for standard game rules score calculation. The higher score is added to higher scoring player, minus the lower score.
    mutating func roundComplete() {
        
        if playerOneRoundScore > playerTwoRoundScore {
            playerOneGameScore += (playerOneRoundScore - playerTwoRoundScore)
        } else if playerTwoRoundScore > playerOneRoundScore {
            playerTwoGameScore += (playerTwoRoundScore - playerOneRoundScore)
        } else {
            playerOneRoundScore = 0
            playerTwoRoundScore = 0

            playerOneInCount = 0
            playerOneOnCount = 0

            playerTwoInCount = 0
            playerTwoOnCount = 0
            return
        }
        
        checkForWin(playerOneScore: playerOneGameScore, playerTwoScore: playerTwoGameScore, gameRules: gameRules)
        
        playerOneRoundScore = 0
        playerTwoRoundScore = 0

        playerOneInCount = 0
        playerOneOnCount = 0

        playerTwoInCount = 0
        playerTwoOnCount = 0
    }
    
    mutating func checkForWin(playerOneScore: Int, playerTwoScore: Int, gameRules: Rules) {
        if playerOneGameScore < 21 || playerTwoGameScore < 21 {
            playerOneWins = false
            playerTwoWins = false
        }
        
        switch gameRules {
            case .tournament:
                playerWins(playerOneScore: playerOneScore, playerTwoScore: playerTwoScore)
            
            case .returnToFifteen:
                guard playerOneScore == 21 || playerTwoScore == 21 else {
                    if playerOneScore > 21 {
                        playerOneGameScore = 15
                    } else if playerTwoScore > 21 {
                        playerTwoGameScore = 15
                    }
                    return
                }
            
                playerWins(playerOneScore: playerOneScore, playerTwoScore: playerTwoScore)
                
                guard playerOneScore != 21 || playerTwoScore != 21 else {
                    playerWins(playerOneScore: playerOneScore, playerTwoScore: playerTwoScore)
                    return
                }
        }
    }
    
    mutating func playerWins(playerOneScore: Int, playerTwoScore: Int) {
        if playerOneScore >= 21 {
            playerOneWins = true
            newGame()
        } else if playerTwoScore >= 21 {
            playerTwoWins = true
            newGame()
        }
    }
    
    mutating func newGame() {

        playerOneGameScore = 0
        playerTwoGameScore = 0
        
        playerOneRoundScore = 0
        playerTwoRoundScore = 0
        
        playerOneInCount = 0
        playerOneOnCount = 0
        
        playerTwoInCount = 0
        playerTwoOnCount = 0
    }
    
    mutating func resetWinStatus() {
        playerOneWins = false
        playerTwoWins = false
    }
    
    mutating func updatePlayerInfo(newName: String, newColor: UIColor, previousName: String) {
        let newName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard newName != "" else {
            showAlert = true
            return
        }
        
        if previousName == playerOne.name {
            guard newName != playerTwo.name else {
                showAlert = true
                return
            }
            playerOne.name = newName
            playerOne.color = newColor
        } else if previousName == playerTwo.name {
            guard newName != playerOne.name else {
                showAlert = true
                return
            }
            playerTwo.name = newName
            playerTwo.color = newColor
        } else {
           return
        }
    }
    
    mutating func handleScoreValidation(player: Player, addOrSubtract: String) -> Bool {
        var valid: Bool = false
        
        if player.name == playerOne.name {
            if throwCountValidation(inCount: playerOneInCount, onCount: playerOneOnCount, addOrSubtract: addOrSubtract) {
                valid = true
            }
        } else if player.name == playerTwo.name {
            if throwCountValidation(inCount: playerTwoInCount, onCount: playerTwoOnCount, addOrSubtract: addOrSubtract) {
                valid = true
            }
        } else {
            valid = false
        }
        
        return valid
    }
    
    func throwCountValidation(inCount: Int, onCount: Int, addOrSubtract: String) -> Bool {
        switch addOrSubtract {
            case "add":
                if inCount + onCount >= 4 {
                    return false
                } else {
                    return true
                }
            case "subtract":
                if inCount + onCount <= 0 {
                    return false
                } else {
                    return true
                }
            default:
                return false
        }
    }
    
    func checkThrowCount(player: Player, inOrOn: String) -> Bool {
        switch (player.name, inOrOn) {
        case (playerOne.name, "in"):
            if playerOneInCount <= 0 {
                return false
            }
            else {
                return true
            }
        case (playerOne.name, "on"):
            if playerOneOnCount <= 0 {
                return false
            }
            else {
                return true
            }
        case (playerTwo.name, "in"):
            if playerTwoInCount <= 0 {
            return false
            }
            else {
                return true
            }
        case (playerTwo.name, "on"):
            if playerTwoOnCount <= 0 {
                return false
            }
            else {
                return true
            }
            
        default:
            return false
        }
    }
    
    mutating func handleThrowCountChange(player: Player, addOrSubtract: String, inOrOn: String) {
        switch (player.name, addOrSubtract, inOrOn) {
            // MARK: Player One
            case (playerOne.name, "add", "in"):
                playerOneInCount += 1
            case (playerOne.name, "add", "on"):
                playerOneOnCount += 1
            case (playerOne.name, "subtract", "in"):
                playerOneInCount -= 1
            case (playerOne.name, "subtract", "on"):
                playerOneOnCount -= 1
            
            // MARK: Player Two
            case (playerTwo.name, "add", "in"):
                playerTwoInCount += 1
            case (playerTwo.name, "add", "on"):
                playerTwoOnCount += 1
            case (playerTwo.name, "subtract", "in"):
                playerTwoInCount -= 1
            case (playerTwo.name, "subtract", "on"):
                playerTwoOnCount -= 1
                    
            default:
                return
        }
    }
    
    func announceScore() {
        guard let speechSynthesizer else { return }
        
        speechSynthesizer.announceScore(playerOneScore: playerOneGameScore, playerTwoScore: playerTwoGameScore, playerOneName: playerOne.name, playerTwoName: playerTwo.name)
    }
    
}
