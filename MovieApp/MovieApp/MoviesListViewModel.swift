import SwiftUI
import MoviesList

public protocol MovieListLoader {
    typealias Result = Swift.Result<[Movie], Error>
    
    func loadMovies(completion: @escaping (Result) -> Void)
}

final class MoviesListViewModel: ObservableObject {
    @Published private var moviesData = [Movie]()
    
    private let category: MoviesList.MovieCategory
    private let moviesLoader: MovieListLoader
    
    init(category: MoviesList.MovieCategory, moviesLoader: MovieListLoader) {
        self.category = category
        self.moviesLoader = moviesLoader
    }
    
    func loadMovies() {
        moviesLoader.loadMovies { result in
            switch result {
            case let .success(movies):
                self.moviesData = movies
            case let .failure(error):
                break
            }
        }
    }
    
    var movies: [MovieViewData] {
        moviesData.map {
            MovieViewData(title: $0.title,
                          releaseDate: $0.releaseDate,
                          imageURL: $0.imageURL,
                          overview: $0.overview)
        }
    }
    
    var navigationTitle: String {
        Self.title(for: category).capitalized
    }
    
    public static func title(for category: MovieCategory) -> String {
        switch category {
        case .nowPlaying: return "now playing"
        case .topRated: return "top rated"
        case .popular: return "popular"
        case .upcoming: return "upcoming"
        @unknown default: return "unknown"
        }
    }
}
