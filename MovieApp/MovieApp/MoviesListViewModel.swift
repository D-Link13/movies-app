import SwiftUI
import MoviesList
import Combine

final class MoviesListViewModel: ObservableObject {
    @Published private var moviesData = [Movie]()
    
    private let category: MoviesList.MovieCategory
    private let moviesLoader: AnyPublisher<[Movie], Error>
    private var cancellables = Set<AnyCancellable>()
    
    init(category: MoviesList.MovieCategory, moviesLoader: AnyPublisher<[Movie], Error>) {
        self.category = category
        self.moviesLoader = moviesLoader
    }
    
    func loadMovies() {
        moviesLoader
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] movies in
                self?.moviesData = movies
            }
            .store(in: &cancellables)
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
        category.title.capitalized
    }
}

extension MoviesList.MovieCategory {
    
    var title: String {
        switch self {
        case .nowPlaying: return "now playing"
        case .topRated: return "top rated"
        case .popular: return "popular"
        case .upcoming: return "upcoming"
        @unknown default: return "unknown"
        }
    }
}
