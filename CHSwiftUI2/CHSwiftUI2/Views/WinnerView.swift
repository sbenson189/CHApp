//
//  WinnerView.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 9/29/22.
//

import SwiftUI

struct WinnerView: View {
    
    var winner: String
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .secondarySystemBackground : .black)
                .ignoresSafeArea()
            VStack {
    
                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                            .fontWeight(.bold)
                            .frame(width: 75, height: 50)
                            .padding(.trailing, 30)
                    }
                }
                Spacer()
                Text("\(winner) wins!")
                    .foregroundColor(Color(.systemGray))
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                Spacer()
            }
            
        }
    }
    
}

struct WinnerView_Previews: PreviewProvider {
    static var previews: some View {
        WinnerView(winner: "Player One")
    }
}
