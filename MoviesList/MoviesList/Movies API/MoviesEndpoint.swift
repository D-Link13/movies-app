import Foundation

public enum MoviesEndpoint {
    case get(category: MovieCategory)
    
    public func request(baseURL: URL) -> URLRequest {
        switch self {
        case .get(let category):
            return URLRequest(url: baseURL.appendingPathComponent("/\(category.path)"))
        }
    }
}


private extension MovieCategory {
    var path: String {
        switch self {
        case .nowPlaying: return "now_playing"
        case .popular: return "popular"
        case .topRated: return "top_rated"
        case .upcoming: return "upcoming"
        }
    }
}
