//
//  ContentView.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 8/21/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var showPlayerOneEdit: Bool = false
    @State var showPlayerTwoEdit: Bool = false
    @State var soundOn: Bool = true
    @State var showPlayerWinView: Bool = false
    @State var showAlert: Bool = false
    
    @ObservedObject var viewModel: ScoreViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .secondarySystemBackground : .black)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    SpeakScoreToggleButtion(soundOn: $soundOn)
                    NewGameButton(viewModel: viewModel)
                }
                .padding(.leading, 200)
                .padding(.bottom, -10)
                
                Spacer()
                
                TextView(text: "Total Score", font: .system(size: 40), foregroundColor: .primary)
                
                PlayerGameScoreHStack(viewModel: viewModel)
                
                HStack {
                    VStack {
                        PlayerOneInfoHStack(viewModel: viewModel, showEdit: $showPlayerOneEdit)
                        
                        InOnButton(
                            inOrOnLabelText: "In",
                            addButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerOne.name, inOrOn: "in", addOrSubtract: "add")},
                            subtractButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerOne.name, inOrOn: "in", addOrSubtract: "subtract")},
                            buttonBackgroundColor: Color(viewModel.gameInfo.playerOne.color)
                        )
                        .cornerRadius(20)
                        
                        InOnButton(
                            inOrOnLabelText: "On",
                            addButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerOne.name, inOrOn: "on", addOrSubtract: "add")},
                            subtractButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerOne.name, inOrOn: "on", addOrSubtract: "subtract")},
                            buttonBackgroundColor: Color(viewModel.gameInfo.playerOne.color)
                        )
                        .cornerRadius(20)
                    }
                    VStack {
                        PlayerTwoInfoHStack(viewModel: viewModel, showEdit: $showPlayerTwoEdit)
                        
                        InOnButton(
                            inOrOnLabelText: "In",
                            addButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerTwo.name, inOrOn: "in", addOrSubtract: "add")},
                            subtractButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerTwo.name, inOrOn: "in", addOrSubtract: "subtract")},
                            buttonBackgroundColor: Color(viewModel.gameInfo.playerTwo.color)
                        )
                        .cornerRadius(20)
                        
                        InOnButton(
                            inOrOnLabelText: "On",
                            addButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerTwo.name, inOrOn: "on", addOrSubtract: "add")},
                            subtractButtonAction: {viewModel.handleInOrOnTap(player: viewModel.gameInfo.playerTwo.name, inOrOn: "on", addOrSubtract: "subtract")},
                            buttonBackgroundColor: Color(viewModel.gameInfo.playerTwo.color)
                        )
                        .cornerRadius(20)
                    }.padding(.leading)
                }
                
                VStack {
                    TextView(text: "Round Score", font: .system(size: 35), foregroundColor: .primary)
                    PlayerRoundScoreHStack(viewModel: viewModel)
                    HStack{
                        ResetRoundButton(action: {viewModel.gameInfo.resetRound()})
                        Button(action: {
                            viewModel.gameInfo.roundComplete()
                            showPlayerWinView = viewModel.determineWinner(soundOn: soundOn)
                        }) {
                            CompleteRoundText()
                        }.sheet(isPresented: $showPlayerWinView, onDismiss: {viewModel.gameInfo.resetWinStatus()}) {
                            WinnerView(winner: viewModel.gameInfo.playerOneWins ? viewModel.gameInfo.playerOne.name : viewModel.gameInfo.playerTwo.name)
                        }
                    }
                }
                Spacer()
            }
        }
        .alert(item: $viewModel.alertItem) { $0.alert }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ScoreViewModel())
    }
}
    
fileprivate struct SpeakScoreToggleButtion: View {
    
    @Binding var soundOn: Bool
    
    var body: some View {
        Button(action: {soundOn.toggle()}) {
            Image(systemName: soundOn ? "speaker.wave.3" : "speaker")
                .foregroundColor(.white)
                .font(.system(size: 30))
        }.frame(width: 75, height: 75, alignment: .center)
            .background(.green)
            .cornerRadius(50)
    }
    
}

fileprivate struct NewGameButton: View {
    
    var viewModel: ScoreViewModel
    
    var body: some View {
        Button(action: {viewModel.gameInfo.newGame()}) {
            Text("New Game")
                .fontWeight(.bold)
                .frame(width: 50, height: 50, alignment: .center)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .lineLimit(2)
        }.frame(width: 75, height: 75, alignment: .center)
            .background(.blue)
            .cornerRadius(50)
    }
    
}

fileprivate struct TextView: View {
    
    var text: String
    var font: Font
    var foregroundColor: Color
    var lineLimit: Int? = nil
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(foregroundColor)
            .lineLimit(lineLimit)
    }
    
}

fileprivate struct ResetRoundButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Text("Reset Round")
                .fontWeight(.bold)
                .frame(width: 150, height: 70, alignment: .center)
                .background(.yellow)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .cornerRadius(20)
        }
    }
    
}

fileprivate struct CompleteRoundText: View {
    
    var body: some View {
        Text("Complete Round")
            .fontWeight(.bold)
            .frame(width: 150, height: 70, alignment: .center)
            .background(.green)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .cornerRadius(20)
    }
    
}

fileprivate struct PlayerGameScoreHStack: View {
    
    @ObservedObject var viewModel: ScoreViewModel
    
    var body: some View {
        HStack {
            TextView(text: String(viewModel.gameInfo.playerOneGameScore), font: .system(size: 65), foregroundColor: Color(viewModel.gameInfo.playerOne.color))
            TextView(text: "-", font: .system(size: 65), foregroundColor: .primary)
            
            TextView(text: String(viewModel.gameInfo.playerTwoGameScore), font: .system(size: 65), foregroundColor: Color(viewModel.gameInfo.playerTwo.color))
        }
    }
    
}

fileprivate struct PlayerOneInfoHStack: View {
    
    @ObservedObject var viewModel: ScoreViewModel
    @Binding var showEdit: Bool
    
    var body: some View {
        HStack {
            TextView(text: "\(viewModel.gameInfo.playerOne.name)", font: .system(size: 20), foregroundColor: Color(viewModel.gameInfo.playerOne.color), lineLimit: 1)
            Button(action: {showEdit.toggle()}) {
                Image(systemName: "pencil.circle")
                    .foregroundColor(.primary)
                    .font(.system(size: 25))
            }.sheet(isPresented: $showEdit) {
                PlayerInfoEditView(name: viewModel.gameInfo.playerOne.name, newName: viewModel.gameInfo.playerOne.name, color: Color(viewModel.gameInfo.playerOne.color), viewModel: viewModel, showPlayerEditor: $showEdit)
            }
        }
    }
    
}

fileprivate struct PlayerTwoInfoHStack: View {
    
    @ObservedObject var viewModel: ScoreViewModel
    @Binding var showEdit: Bool
    
    var body: some View {
        HStack {
            TextView(text: "\(viewModel.gameInfo.playerTwo.name)", font: .system(size: 20), foregroundColor: Color(viewModel.gameInfo.playerTwo.color), lineLimit: 1)
            Button(action: {showEdit.toggle()}) {
                Image(systemName: "pencil.circle")
                    .foregroundColor(.primary)
                    .font(.system(size: 25))
            }.sheet(isPresented: $showEdit) {
                PlayerInfoEditView(name: viewModel.gameInfo.playerTwo.name, newName: viewModel.gameInfo.playerTwo.name, color: Color(viewModel.gameInfo.playerTwo.color), viewModel: viewModel, showPlayerEditor: $showEdit)
            }
        }
        .padding(.trailing)
    }
    
}

fileprivate struct PlayerRoundScoreHStack: View {
    
    @ObservedObject var viewModel: ScoreViewModel
    
    var body: some View {
        HStack {
            TextView(text: String(viewModel.gameInfo.playerOneRoundScore), font: .system(size: 50), foregroundColor: Color(viewModel.gameInfo.playerOne.color))
            TextView(text: "-", font: .system(size: 50), foregroundColor: .primary)
            TextView(text: String(viewModel.gameInfo.playerTwoRoundScore), font: .system(size: 50), foregroundColor: Color(viewModel.gameInfo.playerTwo.color))
        }
    }
    
}
