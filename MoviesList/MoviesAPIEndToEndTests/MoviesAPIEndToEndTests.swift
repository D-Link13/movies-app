import XCTest
import MoviesList

final class MoviesAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETMoviesResult_matchesFixedTestAccountData() {
        switch getMoviesResult() {
        case let .success(feedImages)?:
            XCTAssertEqual(feedImages[0], expectedMovie(at: 0))
            XCTAssertEqual(feedImages[1], expectedMovie(at: 1))
            XCTAssertEqual(feedImages[2], expectedMovie(at: 2))
            XCTAssertEqual(feedImages[3], expectedMovie(at: 3))
            XCTAssertEqual(feedImages[4], expectedMovie(at: 4))
            XCTAssertEqual(feedImages[5], expectedMovie(at: 5))
            XCTAssertEqual(feedImages[6], expectedMovie(at: 6))
            XCTAssertEqual(feedImages[7], expectedMovie(at: 7))
        case let .failure(error)?:
            XCTFail("Expected success, got \(error) instead.")
        default:
            XCTFail("Expected success, got no result instead.")
        }
    }
    
    // MARK: - Helpers
    
    private func getMoviesResult(file: StaticString = #filePath, line: UInt = #line) -> Swift.Result<[Movie], Error>? {
        let client = ephemeralClient()
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: Swift.Result<[Movie], Error>?
        client.get(from: moviesTestServerURLRequest) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try MoviesListMapper.map(data, response))
                } catch {
                    return .failure(error)
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
    
    private let testServerAPIToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YzI4N2M0NjIxZmU4YWUyMzU0MWQ1YmQ1YzdkMTRlZiIsInN1YiI6IjVjYzc4ZTY2YzNhMzY4NGIzNDg1NTE0MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YYs3kLqimXVUcRzzg8-kDLHp8y9hLf1UuEVx0XSYFG0"
    
    private var moviesTestServerURLRequest: URLRequest {
        var request = URLRequest(url: moviesTestServerURL)
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(testServerAPIToken)"
        ]
        return request
    }
    
    private var moviesTestServerURL: URL {
        return URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
    }
    
    private func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    private func expectedMovie(at index: Int) -> Movie {
        Movie(title: title(at: index),
            releaseDate: releaseDate(at: index),
            imageURL: imageURL(at: index))
    }
    
    private func title(at index: Int) -> String {
        return [
            "Deadpool & Wolverine",
            "Inside Out 2",
            "Twisters",
            "Despicable Me 4",
            "Alien: Romulus",
            "Kill",
            "It Ends with Us",
            "Saving Bikini Bottom: The Sandy Cheeks Movie"
        ][index]
    }
    
    private func releaseDate(at index: Int) -> Date {
        return [
            Date(timeIntervalSince1970: 1706047200),
            Date(timeIntervalSince1970: 1704924000),
            Date(timeIntervalSince1970: 1704837600),
            Date(timeIntervalSince1970: 1705701600),
            Date(timeIntervalSince1970: 1705096800),
            Date(timeIntervalSince1970: 1704232800),
            Date(timeIntervalSince1970: 1704578400),
            Date(timeIntervalSince1970: 1704060000)
        ][index]
    }
    
    private func imageURL(at index: Int) -> URL {
        let paths = [
            "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
            "/dbhN0rEVTefOOgtuqEQwp4tXr0X.jpg",
            "/pjnD08FlMAIXsfOLKQbvmO0f0MD.jpg",
            "/wWba3TaojhK7NdycRhoQpsG0FaH.jpg",
            "/b33nnKl1GSFbao4l3fZDDqsMx0F.jpg",
            "/m2zXTuNPkywdYLyWlVyJZW2QOJH.jpg",
            "/AjV6jFJ2YFIluYo4GQf13AA1tqu.jpg",
            "/30YnfZdMNIV7noWLdvmcJS0cbnQ.jpg"
        ]
        return URL(string: "https://image.tmdb.org/t/p/w185/")!.appendingPathComponent(paths[index])
    }

}
