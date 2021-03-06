//
//  DiscoverViewController.swift
//  tMDb
//
//  Created by Nurul Rachmawati on 3/9/17.
//  Copyright © 2017 DyCode. All rights reserved.
//

import UIKit
import Kingfisher
import UIScrollView_InfiniteScroll

class DiscoverViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        self.collectionView.addSubview(refreshControl)
        
        return refreshControl
    }()
    
    var movies: [Movie] = []
    var discoverResponse: DiscoverResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCellId")
        collectionView.addInfiniteScroll { (collectionView) in
            if let page = self.discoverResponse?.page {
                let nextPage = page + 1
                self.discoverMovie(at: nextPage)
            }
        }
        collectionView.setShouldShowInfiniteScrollHandler { (collectionView) -> Bool in
            return self.discoverResponse != nil && !self.refreshControl.isRefreshing
        }
        refreshControl.addTarget(self, action: #selector(DiscoverViewController.refresh(sender:)), for: .valueChanged)
        
        refreshControl.beginRefreshing()
        discoverMovie()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helpers
    
    func refresh(sender: UIRefreshControl) {
        discoverMovie()
    }
    
    func discoverMovie(at page: Int = 1) {
        
        provider.request(.discoverMovie(Date(), page))
            .map(to: DiscoverResponse.self)
            .subscribe { event in
                switch event {
                case .next(let response):
                    self.discoverResponse = response
                    if page == 1 {
                        self.movies = response.results
                    }
                    else {
                        self.movies += response.results
                    }
                    
                case .error(let error):
                    print(error.localizedDescription)
                    self.refreshControl.endRefreshing()
                    self.collectionView.finishInfiniteScroll()
                    
                case .completed:
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.collectionView.finishInfiniteScroll()
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension DiscoverViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCellId", for: indexPath) as! MovieViewCell
        let movie = movies[indexPath.item]
        
        cell.imageView.image = nil
        if let posterUrl = movie.posterUrl, let url = try? posterUrl.asURL() {
            cell.imageView.kf.setImage(with: url)
        }
        cell.titleLabel.text = movie.title?.uppercased()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        cell.subtitleLabel.text = nil
        if let releaseDate = movie.releaseDate, let date = dateFormatter.date(from: releaseDate) {
            
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            cell.subtitleLabel.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.frame.width - 45) / 2.0
        let height: CGFloat = width * goldenRation + 62
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate
extension DiscoverViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = movies[indexPath.item]
        showMovieDetail(withMovieID: movie.id)
    }
}

