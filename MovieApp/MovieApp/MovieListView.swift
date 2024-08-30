import SwiftUI
import MoviesList

struct MovieListView: View {
    let category: MoviesList.Category
    @State var movies: [MovieViewData] = []
    
    var body: some View {
        NavigationView {
            List(movies) { movie in
                MovieListCell(movie: movie)
                    .background(
                        NavigationLink("", destination: MovieDetailsView(overview: movie.overview)).opacity(0)
                    )
            }
            .navigationTitle(category.title.capitalized)
            .navigationBarTitleDisplayMode(.inline)
        }
        .listStyle(.plain)
        .onAppear {
            guard movies.isEmpty else { return }
            updateWithNewState()
        }
        .refreshable {
            updateWithNewState()
        }
    }
    
    private func updateWithNewState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            movies = makeSamples()
        }
    }
}

#Preview {
    MovieListView(category: .nowPlaying, movies: makeSamples())
}

private func makeSamples() -> [MovieViewData] {
    [
        MovieViewData(title: "The Shawshank Redemption",
              releaseDate: Date(timeIntervalSince1970: 759276000),
              imageURL: URL(string: "https://image.tmdb.org/t/p/w185/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg")!,
              overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope."),
        MovieViewData(title: "The Godfather",
              releaseDate: Date(timeIntervalSince1970: 64184400),
              imageURL: URL(string: "https://image.tmdb.org/t/p/w185/3bhkrj58Vtu7enYsRolD1fZdja1.jpg")!,
              overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge."),
        MovieViewData(title: "The Godfather Part II",
              releaseDate: Date(timeIntervalSince1970: 127861200),
              imageURL: URL(string: "https://image.tmdb.org/t/p/w185/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg")!,
              overview: "In the continuing saga of the Corleone crime family, a young Vito Corleone grows up in Sicily and in 1910s New York. In the 1950s, Michael Corleone attempts to expand the family business into Las Vegas, Hollywood and Cuba."),
        MovieViewData(title: "Schindler's List",
              releaseDate: Date(timeIntervalSince1970: 727048800),
              imageURL: URL(string: "https://image.tmdb.org/t/p/w185/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg")!,
              overview: "The true story of how businessman Oskar Schindler saved over a thousand Jewish lives from the Nazis while they worked as slaves in his factory during World War II."),
    ]
}
