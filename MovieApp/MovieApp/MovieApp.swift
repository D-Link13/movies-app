import SwiftUI
import Combine
import MoviesList

@main
struct MovieAppApp: App {
    
    @State private var path = [MovieViewData]()
    
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
    
}

private extension MovieAppApp {
    
    private func tabViewItem(for category: MoviesList.MovieCategory) -> some View {
        navigationView(root: movieList(for: category))
            .tabItem {
                Label(MovieCategoryTitlePresenter.title(for: category), systemImage: "film")
            }
    }
    
    @ViewBuilder
    private func navigationView<Root: View>(root: Root) -> some View {
        if #available(iOS 16, *) {
            NavigationStack(path: $path) { root }
        } else {
            NavigationView { root }
        }
    }
    
    @ViewBuilder
    private func movieList(for category: MoviesList.MovieCategory) -> some View {
        if #available(iOS 16, *) {
            makeMovieListView(for: category)
        } else {
            _makeMovieListView(for: category)
        }
    }
    
    private func _makeMovieListView(for category: MoviesList.MovieCategory) -> some View {
        let nextModel = NextViewModel()
        let detailsModel = MovieDetailsViewModel()
        let nextView = NextView(viewModel: nextModel) {
            MovieDetailsView(viewModel: detailsModel)
                .navigationTitle(detailsModel.navigationTitle)
        }
        let listView = composeListView(
            for: category,
            navigationAction: { _ in nextModel.activate() },
            detailsModel: detailsModel)
        
        return VStack {
            listView
            nextView
        }
    }
    
    @available(iOS 16.0, *)
    private func makeMovieListView(for category: MoviesList.MovieCategory) -> some View {
        let detailsModel = MovieDetailsViewModel()
        let listView = composeListView(
            for: category,
            navigationAction: { path.append($0) },
            detailsModel: detailsModel)
        
        return listView
            .navigationDestination(for: MovieViewData.self) { movie in
                MovieDetailsView(viewModel: detailsModel)
                    .navigationTitle(detailsModel.navigationTitle)
            }
    }
    
    private func composeListView(for category: MoviesList.MovieCategory, navigationAction: @escaping (MovieViewData) -> (), detailsModel: MovieDetailsViewModel) -> some View {
        let listModel = MoviesListViewModel(moviesLoader: makeRemoteMoviesLoader(for: category))
        var listView = MovieListView(viewModel: listModel)
        
        listView.onSelect = { movie in
            detailsModel.overview = movie.overview
            detailsModel.navigationTitle = movie.title
            navigationAction(movie)
        }
        return listView
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
