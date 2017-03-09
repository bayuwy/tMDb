//
//  DiscoverViewController.swift
//  tMDb
//
//  Created by Nurul Rachmawati on 3/9/17.
//  Copyright © 2017 DyCode. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie] = []
    var discoverResponse: DiscoverResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func discoverMovie(at page: Int = 1) {
        
        provider.request(.discover(Date(), page))
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
                    
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
