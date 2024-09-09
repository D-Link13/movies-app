import Foundation
import MoviesList
import Combine

final class LoadMovieListCombineAdapter: MovieListLoader {
    private let moviesLoader: AnyPublisher<[Movie], Error>
    var cancellable: Cancellable?
    
    init(moviesLoader: AnyPublisher<[Movie], Error>) {
        self.moviesLoader = moviesLoader
    }
    
    func loadMovies(completion: @escaping (MovieListLoader.Result) -> Void) {
        cancellable = moviesLoader
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { receivedCompletion in
                    switch receivedCompletion {
                    case .finished: break
                    case.failure(let error): completion(.failure(error))
                    }
                },
                receiveValue: { resource in
                    completion(.success(resource))
                })
    }
}
