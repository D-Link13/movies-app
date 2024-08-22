import Foundation

public struct Movie: Equatable {
    public let title: String
    public let releaseDate: Date
    public let imageURL: URL
    
    public init(title: String, releaseDate: Date, imageURL: URL) {
        self.title = title
        self.releaseDate = releaseDate
        self.imageURL = imageURL
    }
}
