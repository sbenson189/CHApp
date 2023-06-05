//
//  SettingsView.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 9/26/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: ScoreViewModel
    
    @State var tournamentRules: Bool = true
    @State var tournamentRulesSelected: Bool = true
    @State var rulesSelected: String = Rules.tournament.rawValue
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Select Scoring Rules")
                    .font(.title)
                    .bold()
                    .padding()
                
                RulesPickerView(selectedRules: $rulesSelected).onChange(of: rulesSelected) { _ in
                    tournamentRulesSelected = viewModel.determineGameRules(selectedRules: rulesSelected)
                }
                
                Text("Tournament Rules")
                    .font(.headline)
                    .bold()
                Text(RulesText.tournamentRules.rawValue)
                    .padding()
                    .background(tournamentRulesSelected ? Color(.systemGreen).opacity(0.5) : Color(.secondarySystemBackground))
                    .cornerRadius(20)
                    .padding(.bottom)
                    .frame(maxWidth: 600)
                
                Text("Return To Fifteen Rules")
                    .font(.headline)
                    .bold()
                Text(RulesText.returnToFifteen.rawValue)
                    .padding()
                    .background(tournamentRulesSelected ? Color(.secondarySystemBackground) : Color(.systemGreen).opacity(0.5))
                    .cornerRadius(20)
                    .frame(maxWidth: 600)
            }
            .padding([.leading, .trailing])
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: ScoreViewModel())
    }
}


enum RulesText: String {
    case tournamentRules = """
    Each player takes turns throwing all four bag. A round is complete when bags have been thrown.
    
    Scoring:
    A bag in the hole is worth three points and a bag on the board is worth one point.
    
    Winning the Game:
    The first player to reach or exceed 21 points is the winner.
    """
    
    case returnToFifteen = """
    A casual game option when your're looking for something new. All of the tournament rules apply, but the new score rules are below.
    
    Scoring:
    The score to win is exactly 21 in this game. If a player exceeds 21, their score is returned to 15 and the game continues.
    """
}

struct RulesPickerView: View {
    
    @Binding var selectedRules: String
    var options = [Rules.tournament.rawValue, Rules.returnToFifteen.rawValue]
    
    var body: some View {
        Picker("Select Rules", selection: $selectedRules) {
            ForEach(options, id: \.self) { option in
                Text(option)
            }
        }
        .frame(width: 250, height: 50)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .padding(.bottom)
    }
    
}
