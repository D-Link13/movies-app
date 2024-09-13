import SwiftUI
import Combine

struct MovieListView: View {
    @Binding var movies: [MovieViewData]
    var onSelect: ((MovieViewData) -> Void)?
    var loadMovies: (() -> ())?
    
    var body: some View {
        List(movies) { movie in
            Button(action: {
                onSelect?(movie)
            }) {
                MovieListCell(movie: movie)
            }
        }
        .listStyle(.plain)
        .onAppear {
            guard movies.isEmpty else { return }
            loadMovies?()
        }
        .refreshable {
            loadMovies?()
        }
    }
}

#Preview {
    let movies = [
        MovieViewData(
            title: "title",
            releaseDate: .now,
            imageURL: URL(string: "https://image.tmdb.org/t/p/w185/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg")!,
            overview: "overview")
    ]
    MovieListView(movies: .constant(movies))
}
