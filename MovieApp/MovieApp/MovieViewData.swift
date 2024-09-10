import Foundation

struct MovieViewData: Identifiable, Hashable {
    let id: UUID
    let title: String
    let releaseDate: Date
    let imageURL: URL
    let overview: String
    
    init(id: UUID = UUID(), title: String, releaseDate: Date, imageURL: URL, overview: String) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.imageURL = imageURL
        self.overview = overview
    }
    
    var formattedReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-HH"
        return formatter.string(from: releaseDate)
    }
}
