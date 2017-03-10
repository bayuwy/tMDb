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
    var adult: Bool = false
    var overview: String?
    var releaseDate: String?
    var genreIds: [Int] = []
    var id: Int = 0
    var originalTitle: String?
    var originalLanguage: String?
    var title: String?
    var backdropPath: String?
    var popularity: Double = 0.0
    var voteCount: Int = 0
    var video: Bool = false
    var voteAverage: Double = 0.0
    
    var belongsToCollection: String?
    var budget: Int64 = 0
    var genres: [Genre] = []
    var homepage: String?
    var imdbId: String?
    var productionCompanies: [Company] = []
    var productionCountries: [Country] = []
    var revenue: Int64 = 0
    var runtime: Int = 0
    var spokenLanguages: [Language] = []
    var status: String?
    var tagline: String?
    
    var posterUrl: String? {
        if let posterPath = posterPath {
            return "\(posterBaseUrl)\(posterPath)"
        }
        return nil
    }
    
    var backdropUrl: String? {
        if let backdropPath = backdropPath {
            return "\(posterBaseUrl)\(backdropPath)"
        }
        return nil
    }
}
