//
//  ScoreViewModel.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 8/22/22.
//

import Foundation
import UIKit

enum Rules: String {
    case tournament = "Tournament Rules"
    case returnToFifteen = "Return To Fifteen Rules"
}

class ScoreViewModel: ObservableObject {
    
    var playerOne: Player
    var playerTwo: Player
    @Published var gameInfo: Game
    @Published var alert: String = ""
    @Published var alertItem: AlertItem?

    init() {
        self.playerOne = Player(name: "Player1", color: .red)
        self.playerTwo = Player(name: "Player2", color: .blue)
        self.gameInfo = Game(playerOne: playerOne, playerTwo: playerTwo, playerOneGameScore: 0, playerOneRoundScore: 0, playerTwoGameScore: 0, playerTwoRoundScore: 0, playerOneInCount: 0, playerOneOnCount: 0, playerTwoInCount: 0, playerTwoOnCount: 0, showAlert: false, speechSynthesizer: SpeakScore())
    }
    
    // MARK: Function to handle action to add or subtract from player's round score based on user input.
    func handleInOrOnTap(player: String, inOrOn: String, addOrSubtract: String) {
        
        switch (player, inOrOn, addOrSubtract) {
            // MARK: Player One
            case (gameInfo.playerOne.name, "in", "add"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerOne, addOrSubtract: addOrSubtract) else {
                        return
                    }
                    gameInfo.playerOneRoundScore += 3
                    gameInfo.playerOneInCount += 1
            case (gameInfo.playerOne.name, "on", "add"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerOne, addOrSubtract: addOrSubtract) else {
                        return
                    }
                    gameInfo.playerOneRoundScore += 1
                    gameInfo.playerOneOnCount += 1
            case (gameInfo.playerOne.name, "in", "subtract"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerOne, addOrSubtract: addOrSubtract) && gameInfo.checkThrowCount(player: gameInfo.playerOne, inOrOn: "in") else {
                        return
                    }
                    gameInfo.playerOneRoundScore -= 3
                    gameInfo.playerOneInCount -= 1
            case (gameInfo.playerOne.name, "on", "subtract"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerOne, addOrSubtract: addOrSubtract) && gameInfo.checkThrowCount(player: gameInfo.playerOne, inOrOn: "on") else {
                        return
                    }
                    gameInfo.playerOneRoundScore -= 1
                    gameInfo.playerOneOnCount -= 1
        
            // MARK: Player Two
            case (gameInfo.playerTwo.name, "in", "add"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerTwo, addOrSubtract: addOrSubtract) else {
                        return
                    }
                    gameInfo.playerTwoRoundScore += 3
                    gameInfo.playerTwoInCount += 1
            case (gameInfo.playerTwo.name, "on", "add"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerTwo, addOrSubtract: addOrSubtract) else {
                        return
                    }
                    gameInfo.playerTwoRoundScore += 1
                    gameInfo.playerTwoOnCount += 1
            case (gameInfo.playerTwo.name, "in", "subtract"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerTwo, addOrSubtract: addOrSubtract) && gameInfo.checkThrowCount(player: gameInfo.playerTwo, inOrOn: "in") else {
                        return
                    }
                    gameInfo.playerTwoRoundScore -= 3
                    gameInfo.playerTwoInCount -= 1
            case (gameInfo.playerTwo.name, "on", "subtract"):
                guard gameInfo.handleScoreValidation(player: gameInfo.playerTwo, addOrSubtract: addOrSubtract) && gameInfo.checkThrowCount(player: gameInfo.playerTwo, inOrOn: "on") else {
                        return
                    }
                    gameInfo.playerTwoRoundScore -= 1
                    gameInfo.playerTwoOnCount -= 1
    
            default:
                alertItem = AlertContext.unableToCalculateScore
        }
    }
    
    func determineWinner(soundOn: Bool) -> Bool {
        if gameInfo.playerOneWins || gameInfo.playerTwoWins {
            return true
        }
        if soundOn {
            if !gameInfo.playerTwoWins && !gameInfo.playerTwoWins {
                gameInfo.announceScore()
            }
        }
        return false
    }
    
    func determineGameRules(selectedRules: String) -> Bool {
        if selectedRules == Rules.tournament.rawValue {
            gameInfo.gameRules = .tournament
            gameInfo.newGame()
            return true
        } else {
            gameInfo.gameRules = .returnToFifteen
            gameInfo.newGame()
            return false
        }
    }
    
}
