//
//  MovieDetailViewController.swift
//  tMDb
//
//  Created by Nurul Rachmawati on 3/10/17.
//  Copyright © 2017 DyCode. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movieID: Int?
    private var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        loadMovieDetail()
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
    
    func setupViews() {
        
        title = movie?.title == nil ? "" : movie?.title
        titleLabel.text = movie?.title
        overviewLabel.text = movie?.overview
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        subtitleLabel.text = nil
        if let releaseDate = movie?.releaseDate, let date = dateFormatter.date(from: releaseDate) {
            
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            subtitleLabel.text = dateFormatter.string(from: date)
        }
        
        imageView.image = nil
        if let posterUrl = movie?.posterUrl, let url = try? posterUrl.asURL() {
            imageView.kf.setImage(with: url)
        }
    }

    func loadMovieDetail() {
        
        if let movieID = movieID {
            
            provider.request(.movieDetail(movieID))
                .map(to: Movie.self)
                .subscribe { event in
                    switch event {
                    case .next(let response):
                        self.movie = response
                        
                    case .error(let error):
                        print(error.localizedDescription)
                        
                    case .completed:
                        self.setupViews()
                    }
                }
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - UIViewController
extension UIViewController {
 
    func showMovieDetail(withMovieID movieID: Int?) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
        viewController.movieID = movieID
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
