//
//  InOnButton.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 8/22/22.
//

import SwiftUI

struct InOnButton: View {
    
    var inOrOnLabelText: String = "On"
    var addButtonAction: () -> Void = {}
    var subtractButtonAction: () -> Void = {}
    var buttonBackgroundColor = Color.red
    
    var body: some View {
        ZStack {
            Text(inOrOnLabelText)
                .frame(width: 150, height: 100, alignment: .center)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .background(buttonBackgroundColor)
                .cornerRadius(20)
            HStack {
                Button(action: subtractButtonAction) {
                    Text("-")
                        .frame(width: 40, height: 100, alignment: .center)
                        .background(.clear)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                
                Button(action: addButtonAction) {
                    Text("+")
                        .frame(width: 40, height: 100, alignment: .center)
                        .background(.clear)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(.leading, 30)
                }
            }
        }.padding(0)
    }
    
}

struct InOnButton_Previews: PreviewProvider {
    static var previews: some View {
        InOnButton()
    }
}
