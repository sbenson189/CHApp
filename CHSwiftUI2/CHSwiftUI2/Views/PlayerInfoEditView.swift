//
//  PlayerInfoEditView.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 8/23/22.
//

import SwiftUI
import UIKit

let colors: [Color] = [.blue, .brown, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red, .teal, .yellow]

struct PlayerInfoEditView: View {
    
    @State var name: String
    @State var newName: String
    @State var color: Color                 = .red
    @State private var showingAlert         = false
    @State var colorSelectionButtonTapped   = false
    @State var highlightedColor: Color      = .cyan
    
    @Environment(\.presentationMode) var presentationMode
    
    var viewModel: ScoreViewModel
    
    @Binding var showPlayerEditor: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            VStack(alignment: .trailing) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Dismiss")
                        .fontWeight(.bold)
                        .frame(width: 75, height: 50)
                        .padding(.trailing, 20)
                }
                
                Form {
                    Section("Enter Name") {
                        HStack {
                            TextEditor(text: $newName)
                                .onChange(of: newName, perform: { newName in
                                    if newName.count >= 11 {
                                        return self.newName.removeLast(1)
                                    }
                                })
                                .frame(height: 35)
                        }
                    }
                    
                    Section("Choose Color") {
                        List(colors, id: \.self) { colorOption in
                            ColorSelectionView(chosenColor: $color, inputColor: colorOption)
                                .frame(height: 50)
                                .foregroundColor(highlightedColor == colorOption ? colorOption : colorOption.opacity(0.2))
                                .onTapGesture {
                                    highlightedColor = colorOption
                                }
                        }
                    }
                    Section(header: Text("")) {
                        EmptyView()
                            
                    }.frame(height: 30)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Invalid name entered"), message: Text("Name cannot be blank or the same as the other player"), dismissButton: .default(Text("Got it!"), action: {viewModel.gameInfo.showAlert = false}))
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.gameInfo.updatePlayerInfo(newName: newName, newColor: UIColor(highlightedColor), previousName: name)
                        showingAlert = viewModel.gameInfo.showAlert
                        if !showingAlert {
                            showPlayerEditor = false
                        }
                    }) {
                        
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(.largeTitle))
                            .frame(width: 80, height: 80)
                            .background(.blue)
                            .clipShape(Circle())
                            .padding(.trailing, 25)
                    }
                }
            }
  
        }
    }
    
}

struct PlayerInfoEditView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerInfoEditView(name: "Player1", newName: "", viewModel: ScoreViewModel(), showPlayerEditor: .constant(true))
    }
}

struct ColorSelectionView: View {
    
    @Binding var chosenColor: Color
    @State var inputColor: Color
    
    var body: some View {
        Button {
            chosenColor = inputColor
        } label: {
            Rectangle()
                .tint(inputColor)
        }
    }
    
}
