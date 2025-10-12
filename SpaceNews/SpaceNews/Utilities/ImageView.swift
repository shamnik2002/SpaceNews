//
//  ImageView.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//
import Foundation
import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ImageView: View {
 
    @StateObject var viewModel: ImageViewModel
    
    var body: some View {
        
        WebImage(url: viewModel.url)
            .resizable()
    }
}

final class ImageViewModel: ObservableObject {
    
    @Published var url: URL?
 
    init(url: URL? = nil) {
        self.url = url
    }
}
