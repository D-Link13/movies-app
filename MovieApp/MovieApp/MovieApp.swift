import SwiftUI
import Combine
import MoviesList

@main
struct MovieAppApp: App {
    
    private let httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                tabViewItem(for: .nowPlaying)
                tabViewItem(for: .topRated)
                tabViewItem(for: .popular)
                tabViewItem(for: .upcoming)
            }
        }
    }
    
}

private extension MovieAppApp {
    
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3/movie")! }
    var testServerAPIToken: String {
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YzI4N2M0NjIxZmU4YWUyMzU0MWQ1YmQ1YzdkMTRlZiIsInN1YiI6IjVjYzc4ZTY2YzNhMzY4NGIzNDg1NTE0MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YYs3kLqimXVUcRzzg8-kDLHp8y9hLf1UuEVx0XSYFG0"
    }
    
    @ViewBuilder
    func tabViewItem(for category: MoviesList.MovieCategory) -> some View {
        MovieListComposer.movieListComposed(
            with: category,
            moviesLoader: makeRemoteMoviesLoader(for: category)
        )
        .tabItem {
            Label(MoviesListViewModel.title(for: category).capitalized, systemImage: "film")
        }
    }
    
    private func makeRemoteMoviesLoader(for category: MoviesList.MovieCategory) -> AnyPublisher<[Movie], Error> {
        var request = MoviesEndpoint.get(category: category).request(baseURL: baseURL)
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(testServerAPIToken)"
        ]
        
        return httpClient
            .getPublisher(from: request)
            .tryMap(MoviesListMapper.map)
            .eraseToAnyPublisher()
    }
    
}
