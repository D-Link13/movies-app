//
//  ServerResponse.swift
//  MovieApp
//
//  Created by Someone on 2024-02-25.
//

import Foundation

// MARK: - ServerResponse

struct ServerResponse: Decodable {
    
    // MARK: CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movies = try container.decode([Movie].self, forKey: .results)
    }
    
    // MARK: Internal

    let movies: [Movie]?

}
