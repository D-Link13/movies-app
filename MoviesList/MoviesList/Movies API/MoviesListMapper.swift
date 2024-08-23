import Foundation

public final class MoviesListMapper {
    
    public static let baseURL = URL(string: "https://image.tmdb.org/t/p/w185/")!
    
    private struct Root: Decodable {
        private let results: [Item]
        
        private struct Item: Decodable {
            
            enum CodingKeys: String, CodingKey {
                case title
                case releaseDate = "release_date"
                case posterPath = "poster_path"
            }
            
            let title: String
            let releaseDate: Date
            let posterPath: String
            
            var imageURL: URL { MoviesListMapper.baseURL.appendingPathComponent(posterPath) }
        }
        
        var movies: [Movie] {
            results.map {
                Movie(
                    title: $0.title,
                    releaseDate: $0.releaseDate,
                    imageURL: $0.imageURL)
            }
        }
    }
    
    private enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Movie] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard response.isOK,
              let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.movies
    }
}

private extension HTTPURLResponse {
    private static var OK_200: Int { 200 }
    
    var isOK: Bool {
        statusCode == HTTPURLResponse.OK_200
    }
}
