//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Someone on 2024-02-25.
//

import Foundation

// MARK: - NetworkManager

struct NetworkManager {

    /// API Documentation; these are not the API paths:
    /// - Now Playing https://developers.themoviedb.org/3/movies/get-now-playing
    /// - Popular https://developers.themoviedb.org/3/movies/get-popular-movies
    /// - Top Rated https://developers.themoviedb.org/3/movies/get-top-rated-movies
    /// - Upcoming https://developers.themoviedb.org/3/movies/get-upcoming
    
    // MARK: - APIConstants
    
    private struct APIConstants {
        static let baseURL = "https://api.themoviedb.org/3/movie"
        static let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YzI4N2M0NjIxZmU4YWUyMzU0MWQ1YmQ1YzdkMTRlZiIsInN1YiI6IjVjYzc4ZTY2YzNhMzY4NGIzNDg1NTE0MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YYs3kLqimXVUcRzzg8-kDLHp8y9hLf1UuEVx0XSYFG0"
    }

    // MARK: Internal

    /// An example function to fetch a list of 'top rated' movies.
    /// This function can be modified as needed or used as reference.
    func fetchList() {
        guard let url = URL(string: "\(APIConstants.baseURL)/top_rated") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(APIConstants.token)"
          ]

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let data {
                let _ = self.parseData(data)
            }
            // Handle data, response and error
        }

        dataTask.resume()
    }

    // MARK: Private

    private func parseData(_ data: Data) -> ServerResponse? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ServerResponse.self, from: data)
            return response
        } catch {
            return nil
        }
    }
}

