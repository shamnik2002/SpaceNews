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
            SpaceNewsCollectionViewControllerRepresentable()
                .edgesIgnoringSafeArea(.all)
            .navigationTitle("Home")
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}

struct SpaceNewsCollectionViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SpaceNewsCollectionViewController {
        let viewModel = SpaceNewsControllerViewModel(appStore: AppStore.shared, category: .home)
        let vc = SpaceNewsCollectionViewController(viewModel: viewModel)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SpaceNewsCollectionViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = SpaceNewsCollectionViewController
    
    
    
}
