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
    
    private func tabViewItem(for category: MoviesList.MovieCategory) -> some View {
        NavigationView {
            makeMovieListView(for: category)
        }
        .tabItem {
            Label(MovieCategoryTitlePresenter.title(for: category), systemImage: "film")
        }
    }
    
    private func makeMovieListView(for category: MoviesList.MovieCategory) -> some View {
        let nextModel = NextViewModel()
        let detailsModel = MovieDetailsViewModel()
        let nextView = NextView(viewModel: nextModel) {
            MovieDetailsView(viewModel: detailsModel)
                .navigationTitle(detailsModel.navigationTitle)
        }
        
        let listModel = MoviesListViewModel(moviesLoader: makeRemoteMoviesLoader(for: category))
        var listView = MovieListView(viewModel: listModel)
        
        listView.onSelect = { movie in
            detailsModel.overview = movie.overview
            detailsModel.navigationTitle = movie.title
            nextModel.activate()
        }
        
        return VStack {
            listView
            nextView
        }
        .navigationTitle(MovieCategoryTitlePresenter.title(for: category))
        .navigationBarTitleDisplayMode(.inline)
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
