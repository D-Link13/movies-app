//
//  Movie.swift
//  MovieApp
//
//  Created by Someone on 2024-02-25.
//

import Foundation

// MARK: - Movie

struct Movie: Codable {
    
    // MARK: CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
    }

    // MARK: Internal
    
    let title: String
    let posterPath: String?
    
    var formattedPosterURL: String? {
        guard let path = posterPath else {
            return nil
        }

        return "https://image.tmdb.org/t/p/w185/" + path
    }
    
}
