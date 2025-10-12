//
//  HomeView.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//
import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            SpaceNewsCollectionViewControllerRepresentable(appStore: viewModel.appStore)
                .edgesIgnoringSafeArea(.all)
            .navigationTitle("Home")
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}

struct SpaceNewsCollectionViewControllerRepresentable: UIViewControllerRepresentable {
    
    private let appStore: AppStore
    
    init(appStore: AppStore) {
        self.appStore = appStore
    }
    
    func makeUIViewController(context: Context) -> SpaceNewsCollectionViewController {
        let viewModel = SpaceNewsControllerViewModel(appStore: appStore, category: .home)
        let vc = SpaceNewsCollectionViewController(viewModel: viewModel)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SpaceNewsCollectionViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = SpaceNewsCollectionViewController
    
    
    
}
