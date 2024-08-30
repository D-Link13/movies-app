import XCTest
import MoviesList

final class MoviesListMapperTests: XCTestCase {
    
    func test_map_throwErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try MoviesListMapper.map(json, HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOnInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try MoviesListMapper.map(invalidJSON, HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSON() throws {
        let emptyJSON = makeItemsJSON([])
        
        let result = try MoviesListMapper.map(emptyJSON, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeMovieListItem(
            title: "title",
            releaseDate: (Date(timeIntervalSince1970: 1706047200), "2024-07-24"),
            posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
            overview: "overview1"
        )
        let item2 = makeMovieListItem(
            title: "a long long title",
            releaseDate: (Date(timeIntervalSince1970: 1704924000), "2024-06-11"),
            posterPath: "/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg",
            overview: "overview2"
        )
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try MoviesListMapper.map(json, HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
    private func makeMovieListItem(
        title: String,
        releaseDate: (date: Date, dateString: String),
        posterPath: String,
        overview: String) -> (model: Movie, json: [String: Any]) {
            let model = Movie(
                title: title,
                releaseDate: releaseDate.date,
                imageURL: MoviesListMapper.baseURL.appendingPathComponent(posterPath),
                overview: overview
            )
            let json: [String: Any] = [
                "title": model.title,
                "release_date": releaseDate.dateString,
                "poster_path": posterPath,
                "overview": overview
            ]
            return (model, json)
        }
}

