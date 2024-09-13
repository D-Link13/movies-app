import SwiftUI
import MoviesList
import Combine

final class MoviesListViewModel: ObservableObject {
    @Published var movies = [MovieViewData]()
    
    private let moviesLoader: AnyPublisher<[Movie], Error>
    private var cancellables = Set<AnyCancellable>()
    
    init(moviesLoader: AnyPublisher<[Movie], Error>) {
        self.moviesLoader = moviesLoader
    }
    
    func loadMovies() {
        moviesLoader
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] movies in
                self?.movies = movies.map {
                    MovieViewData(title: $0.title,
                                  releaseDate: $0.releaseDate,
                                  imageURL: $0.imageURL,
                                  overview: $0.overview)
                }
            }
            .store(in: &cancellables)
    }
}
