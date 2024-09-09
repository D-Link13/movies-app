import Foundation
import MoviesList

final class MovieCategoryTitlePresenter {
    
    static func title(for category: MovieCategory) -> String {
        _title(for: category).capitalized
    }
    
    private static func _title(for category: MovieCategory) -> String {
        switch category {
        case .nowPlaying: return "now playing"
        case .topRated: return "top rated"
        case .popular: return "popular"
        case .upcoming: return "upcoming"
        @unknown default: return "unknown"
        }
    }
}

