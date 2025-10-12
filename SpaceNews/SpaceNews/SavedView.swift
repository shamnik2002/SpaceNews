//
//  SavedView.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//
import SwiftUI
import Combine
import UIKit

struct SavedView: View {
    
    @StateObject var viewModel: SavedViewModel
    
    var body: some View {
        NavigationStack {
            SavedCollectionViewControllerRepresentable(appStore: viewModel.appStore)
                .edgesIgnoringSafeArea(.all)
            .navigationTitle("Saved")
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}

struct SavedCollectionViewControllerRepresentable: UIViewControllerRepresentable {
    private let appStore: AppStore
    init(appStore: AppStore) {
        self.appStore = appStore
    }
    func makeUIViewController(context: Context) -> SpaceNewsCollectionViewController {
        let viewModel = SavedNewsControllerViewModel(appStore: appStore, category: .saved)
        let vc = SpaceNewsCollectionViewController(viewModel: viewModel)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SpaceNewsCollectionViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = SpaceNewsCollectionViewController
}
