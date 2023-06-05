//
//  PlayerModel.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 8/23/22.
//

import Foundation
import UIKit

struct Player {
    
    var name: String
    var color: UIColor
    
    mutating func updatePlayerInfo(newName: String, newColor: UIColor) {
        name = newName
        color = newColor
    }
    
}
