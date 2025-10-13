//
//  SearchResultsViewController.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/12/25.
//
import UIKit
import Combine
import SwiftUI
import Foundation

final class SearchResultsViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var viewModel: SearchResultsViewModel
    private var searchResults: [SpaceNewsModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 375, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .lightGray
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        guard let collectionView else { return }
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.register(SpaceNewsCollectionViewCell.self, forCellWithReuseIdentifier: "news")
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.newsPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] searchResults in                
                self?.searchResults = searchResults
                self?.collectionView?.reloadData()
            }.store(in: &cancellables)
    }
}

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "news", for: indexPath) as? SpaceNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let newsItem = searchResults[indexPath.row]
        cell.setup(news: newsItem, isSaved: viewModel.isSavedNewsItem(newsItem), onSave: viewModel.onSave(newsItem:isSaved:))
        return cell
    }
    
    
}

extension SearchResultsViewController: UICollectionViewDelegate {
    
}
