//
//  SpaceNewsCollectionView.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import UIKit
import Combine
import SwiftUI

protocol SpaceNewsCollectionViewModelProtocol {
    var newsPublisher: PassthroughSubject<[SpaceNewsModel], Never> { get }
    func fetchNews()
    func fetchMoreNews()
    func isSavedNewsItem(_ news: SpaceNewsModel) -> Bool
    func onSave(newsItem: SpaceNewsModel, isSaved: Bool)
    func showDetailVC(news: SpaceNewsModel, presentingVC: UIViewController)
}

final class SpaceNewsCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var news: [SpaceNewsModel] = []
    private var viewModel: SpaceNewsCollectionViewModelProtocol
    private var pullToRefresh: UIRefreshControl?
    
    var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: SpaceNewsCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.itemSize = CGSize(width: 375, height: 150)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(SpaceNewsCollectionViewCell.self, forCellWithReuseIdentifier: "news")
        collectionView?.backgroundColor = .lightText
        pullToRefresh = UIRefreshControl()
        collectionView?.refreshControl = pullToRefresh
        pullToRefresh?.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        guard let collectionView else { return }
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.reloadData()
        self.viewModel.newsPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] news in
                self?.news = news
                self?.pullToRefresh?.endRefreshing()
                self?.collectionView?.reloadData()
            }.store(in: &cancellables)
        viewModel.fetchNews()
    }
    
    @objc func onPullToRefresh() {
        viewModel.fetchNews()
    }
}

extension SpaceNewsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "news", for: indexPath) as? SpaceNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let newsItem = news[indexPath.row]
        cell.setup(news: newsItem, isSaved: viewModel.isSavedNewsItem(newsItem), onSave: viewModel.onSave(newsItem:isSaved:))
        return cell
    }
}

extension SpaceNewsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == news.count - 2 {
            viewModel.fetchMoreNews()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetailVC(news: news[indexPath.row], presentingVC: self)
    }
}

