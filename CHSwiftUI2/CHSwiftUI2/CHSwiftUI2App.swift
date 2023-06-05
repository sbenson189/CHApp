//
//  CHSwiftUI2App.swift
//  CHSwiftUI2
//
//  Created by Scott Benson on 8/21/22.
//

import SwiftUI

@main
struct CHSwiftUI2App: App {
    
    @StateObject var viewModel: ScoreViewModel = ScoreViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(viewModel: viewModel)
                    .tabItem {
                        Label("Score", systemImage: "gamecontroller")
                    }
                SettingsView(viewModel: viewModel)
                    .tabItem {
                        Label("Settings", systemImage: "list.bullet")
                    }
            }
        }
    }
    
}
