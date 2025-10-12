//
//  ContentView.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel.homeViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SavedView(viewModel: viewModel.savedViewModel)
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
        }.accentColor(Color(.systemBlue))
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(appStore: AppStore()))
}
