import SwiftUI
import Combine
import MoviesList

fileprivate let httpClient: HTTPClient = {
    URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
}()

private let baseURL = URL(string: "https://api.themoviedb.org/3/movie")!
private let testServerAPIToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YzI4N2M0NjIxZmU4YWUyMzU0MWQ1YmQ1YzdkMTRlZiIsInN1YiI6IjVjYzc4ZTY2YzNhMzY4NGIzNDg1NTE0MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YYs3kLqimXVUcRzzg8-kDLHp8y9hLf1UuEVx0XSYFG0"

fileprivate func makeRemoteMoviesLoader(for category: MoviesList.MovieCategory) -> AnyPublisher<[Movie], Error> {
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

@main
struct MovieAppApp: App {
    
    @StateObject var nowPlayingListModel = MoviesListViewModel(moviesLoader: makeRemoteMoviesLoader(for: .nowPlaying))
    @StateObject var popularListModel = MoviesListViewModel(moviesLoader: makeRemoteMoviesLoader(for: .popular))
    @StateObject var topRatedListModel = MoviesListViewModel(moviesLoader: makeRemoteMoviesLoader(for: .topRated))
    @StateObject var upcomingListModel = MoviesListViewModel(moviesLoader: makeRemoteMoviesLoader(for: .upcoming))
    
    @StateObject var nowPlayingDetailsModel = MovieDetailsViewModel()
    @StateObject var popularDetailsModel = MovieDetailsViewModel()
    @StateObject var topRatedDetailsModel = MovieDetailsViewModel()
    @StateObject var upcomingDetailsModel = MovieDetailsViewModel()
    
    @StateObject var nowPlayingNextModel = NextViewModel()
    @StateObject var popularNextModel = NextViewModel()
    @StateObject var topRatedNextModel = NextViewModel()
    @StateObject var upcomingNextModel = NextViewModel()
    
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
    
    private func tabViewItem(for category: MoviesList.MovieCategory) -> some View {
        NavigationView {
            makeMovieListView(for: category)
        }
        .tabItem {
            Label(MovieCategoryTitlePresenter.title(for: category), systemImage: "film")
        }
    }
    
    private func models(for category: MovieCategory) -> (listModel: MoviesListViewModel, nextModel: NextViewModel, detailsModel: MovieDetailsViewModel) {
        switch category {
        case .nowPlaying: return (nowPlayingListModel, nowPlayingNextModel, nowPlayingDetailsModel)
        case .popular: return (popularListModel, popularNextModel, popularDetailsModel)
        case .topRated: return (topRatedListModel, topRatedNextModel, topRatedDetailsModel)
        case .upcoming: return (upcomingListModel, upcomingNextModel, upcomingDetailsModel)
        @unknown default: fatalError()
        }
    }
    
    private func makeMovieListView(for category: MoviesList.MovieCategory) -> some View {
        @ObservedObject var listModel = models(for: category).listModel
        @ObservedObject var nextModel = models(for: category).nextModel
        @ObservedObject var detailsModel = models(for: category).detailsModel
        
        let nextView = NextView(isActive: $nextModel.isActive) {
            MovieDetailsView(overview: $detailsModel.overview)
                .navigationTitle(detailsModel.navigationTitle)
        }
        
        var listView = MovieListView(movies: $listModel.movies, loadMovies: listModel.loadMovies)
        
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
    
}
