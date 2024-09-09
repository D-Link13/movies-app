import Foundation
import MoviesList
import Combine

final class MovieListComposer {
    
    static func movieListComposed(with category: MovieCategory, moviesLoader: AnyPublisher<[Movie], Error>) -> MovieListView {
        
        let adapter = LoadMovieListCombineAdapter(moviesLoader: moviesLoader)
        let model = MoviesListViewModel(
            category: category,
            moviesLoader: adapter)
        return MovieListView(viewModel: model)
    }
}
