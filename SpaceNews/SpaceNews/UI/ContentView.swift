//
//  ContentView.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    @Environment(\.scenePhase) private var scenePhase
    
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
            SearchView(viewModel: viewModel.searchViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }.accentColor(Color(.systemBlue))
            .onChange(of: scenePhase) { oldValue, newValue in
                switch newValue {
                    case .background:
                        viewModel.saveSavedNewsToDisk()
                        break
                    default:
                        break
                }
            }
    }
}

//#Preview {
//    ContentView(viewModel: ContentViewModel(appStore: AppStore()))
//}
