import SwiftUI
import Combine

struct MovieListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    var onSelect: ((MovieViewData) -> Void)?
    
    var body: some View {
        List(viewModel.movies) { movie in
            Button(action: {
                onSelect?(movie)
            }) {
                MovieListCell(movie: movie)
            }
        }
        .listStyle(.plain)
        .onAppear {
            guard viewModel.movies.isEmpty else { return }
            viewModel.loadMovies()
        }
        .refreshable {
            viewModel.loadMovies()
        }
    }
}

#Preview {
    MovieListView(viewModel: MoviesListViewModel(moviesLoader: Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()), onSelect: { _ in })
}
