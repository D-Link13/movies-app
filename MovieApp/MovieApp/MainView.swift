import SwiftUI
import MoviesList

struct MainView: View {
    
    var body: some View {
        TabView {
            tabViewItem(for: .nowPlaying)
            tabViewItem(for: .topRated)
            tabViewItem(for: .popular)
            tabViewItem(for: .upcoming)
        }
    }
    
    @ViewBuilder
    func tabViewItem(for category: MoviesList.Category) -> some View {
        MovieListView(category: category)
            .tabItem {
                Label(category.title.capitalized, systemImage: "film")
        }
    }
}

#Preview {
    MainView()
}

extension MoviesList.Category {
    var title: String {
        switch self {
        case .nowPlaying: return "now playing"
        case .topRated: return "top rated"
        case .popular: return "popular"
        case .upcoming: return "upcoming"
        @unknown default: return "unknown"
        }
    }
}
