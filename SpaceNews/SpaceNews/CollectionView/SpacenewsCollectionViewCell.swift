//
//  SpacenewsCollectionViewCell.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//
import SwiftUI
import Combine
import UIKit

final class SpaceNewsCollectionViewCell: UICollectionViewCell {
    
    
    private var hostingController: UIHostingController<SpaceNewsCell>?
    override init(frame: CGRect) {

        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
      }
    
    func setup(news: SpaceNewsModel, isSaved: Bool, onSave: @escaping (SpaceNewsModel, Bool) -> Void) {
        
        let viewModel = SpaceNewsCellViewModel(newsItem: news, isSaved: isSaved, onSave: onSave)
        guard hostingController == nil else {
            hostingController?.rootView.viewModel = viewModel
            return
        }
        
        let spaceNewsCell = SpaceNewsCell(viewModel: viewModel)        
        let hostingController = UIHostingController(rootView: spaceNewsCell)
        self.hostingController = hostingController
        self.hostingController?.view.backgroundColor = .clear
        contentView.addSubview(hostingController.view)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
