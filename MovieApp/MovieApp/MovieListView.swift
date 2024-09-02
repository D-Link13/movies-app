import SwiftUI
import Combine

struct MovieListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                MovieListCell(movie: movie)
                    .background(
                        NavigationLink("", destination: MovieDetailsView(overview: movie.overview)).opacity(0)
                    )
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
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
    MovieListView(viewModel: MoviesListViewModel(category: .nowPlaying, moviesLoader: Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()))
}
