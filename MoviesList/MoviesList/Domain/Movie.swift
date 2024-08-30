import Foundation

public struct Movie: Equatable {
    public let title: String
    public let releaseDate: Date
    public let imageURL: URL
    public let overview: String
    
    public init(title: String, releaseDate: Date, imageURL: URL, overview: String) {
        self.title = title
        self.releaseDate = releaseDate
        self.imageURL = imageURL
        self.overview = overview
    }
}
