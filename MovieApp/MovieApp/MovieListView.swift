import SwiftUI
import MoviesList
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
    let movie = Movie(
        title: "title",
        releaseDate: .now,
        imageURL: URL(string: "https://image.tmdb.org/t/p/w185/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg")!,
        overview: "overview")
    let model = MoviesListViewModel(
        moviesLoader: Just([movie])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher())
    return MovieListView(viewModel: model, onSelect: { _ in })
}
