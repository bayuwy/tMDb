//
//  Movie.swift
//  tMDb
//
//  Created by Nurul Rachmawati on 3/9/17.
//  Copyright © 2017 DyCode. All rights reserved.
//

import UIKit
import EVReflection

class Movie: EVObject {

    var posterPath: String?
    var adult: Bool?
    var overview: String?
    var releaseDate: String?
    var genreIds: [Int] = []
    var id: Int = 0
    var originalTitle: String?
    var originalLanguage: String?
    var title: String?
    var backdropPath: String?
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var voteAverage: Double?
}
