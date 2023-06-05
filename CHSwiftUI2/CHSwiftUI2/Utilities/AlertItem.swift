//
//  AlertItem.swift
//  Cornhole Point Keeper
//
//  Created by Scott Benson on 1/26/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
    
    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
    
}

struct AlertContext {
    
    static let unableToCalculateScore = AlertItem(
        title: Text("Score Error"),
        message: Text("Unable to calculate score, please try again. If the problem persists restart the app."),
        dismissButton: .default(Text("Ok"))
    )
    
}
