//
//  DiscoverResponse.swift
//  tMDb
//
//  Created by Nurul Rachmawati on 3/9/17.
//  Copyright © 2017 DyCode. All rights reserved.
//

import UIKit
import EVReflection

class DiscoverResponse: EVObject {

    var page: Int = 0
    var results: [Movie] = []
    var totalResults: Int = 0
    var totalPages: Int = 0
}
