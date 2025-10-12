//
//  SpaceNewsCell.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import SwiftUI
import Combine

struct SpaceNewsCell: View {
    
    @ObservedObject var viewModel: SpaceNewsCellViewModel {
        didSet {
            imageViewModel.url = viewModel.url
        }
    }
    
    var imageViewModel = ImageViewModel(url: nil)
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: viewModel.date)
    }
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(viewModel.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                Spacer()
                HStack(alignment: .bottom, spacing: 10) {
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: viewModel.isSaved ? "heart.fill": "heart")
                        .foregroundColor(Color.red)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            viewModel.saveNewsItem()
                        }
                }
            }
            Spacer()
            ImageView(viewModel: imageViewModel)
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
        }
        .frame(maxWidth: .infinity)   // makes HStack expand horizontally
        .padding(15)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

final class SpaceNewsCellViewModel: ObservableObject {
    
    let newsItem: SpaceNewsModel
    var title: String {
        return newsItem.title ?? ""
    }
    var summary: String {
        return newsItem.summary ?? ""
    }
    var url: URL? {
        guard let urlString = newsItem.image_url else { return nil }
        return URL(string: urlString)
    }
    var date: Date {
        return Date()
    }
    
    var isSaved: Bool
    var onSave:(SpaceNewsModel, Bool) -> Void
    
    init(newsItem: SpaceNewsModel, isSaved: Bool, onSave: @escaping ((SpaceNewsModel, Bool) -> Void)) {
        self.newsItem = newsItem
        self.isSaved = isSaved
        self.onSave = onSave
    }
    
    func saveNewsItem() {
        onSave(newsItem, !isSaved)
    }
}

