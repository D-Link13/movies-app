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
        return URL(string: "https://api.themoviedb.org/3/movie/top_rated")!
    }
    
    private func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    private func expectedMovie(at index: Int) -> Movie {
        Movie(title: title(at: index),
              releaseDate: releaseDate(at: index),
              imageURL: imageURL(at: index),
              overview: overview(at: index))
    }
    
    private func title(at index: Int) -> String {
        return [
            "The Shawshank Redemption",
            "The Godfather",
            "The Godfather Part II",
            "Schindler's List",
            "12 Angry Men",
            "Spirited Away",
            "Dilwale Dulhania Le Jayenge",
            "The Dark Knight"
        ][index]
    }
    
    private func releaseDate(at index: Int) -> Date {
        return [
            Date(timeIntervalSince1970: 759276000),
            Date(timeIntervalSince1970: 64184400),
            Date(timeIntervalSince1970: 127861200),
            Date(timeIntervalSince1970: 727048800),
            Date(timeIntervalSince1970: -409460400),
            Date(timeIntervalSince1970: 979941600),
            Date(timeIntervalSince1970: 790552800),
            Date(timeIntervalSince1970: 1200434400)
        ][index]
    }
    
    private func imageURL(at index: Int) -> URL {
        let paths = [
            "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
            "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
            "/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg",
            "/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg",
            "/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg",
            "/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg",
            "/lfRkUr7DYdHldAqi3PwdQGBRBPM.jpg",
            "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"
        ]
        return URL(string: "https://image.tmdb.org/t/p/w185/")!.appendingPathComponent(paths[index])
    }
    
    private func overview(at index: Int) -> String {
        [
            "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
            "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.",
            "In the continuing saga of the Corleone crime family, a young Vito Corleone grows up in Sicily and in 1910s New York. In the 1950s, Michael Corleone attempts to expand the family business into Las Vegas, Hollywood and Cuba.",
            "The true story of how businessman Oskar Schindler saved over a thousand Jewish lives from the Nazis while they worked as slaves in his factory during World War II.",
            "The defense and the prosecution have rested and the jury is filing into the jury room to decide if a young Spanish-American is guilty or innocent of murdering his father. What begins as an open and shut case soon becomes a mini-drama of each of the jurors' prejudices and preconceptions about the trial, the accused, and each other.",
            "A young girl, Chihiro, becomes trapped in a strange new world of spirits. When her parents undergo a mysterious transformation, she must call upon the courage she never knew she had to free her family.",
            "Raj is a rich, carefree, happy-go-lucky second generation NRI. Simran is the daughter of Chaudhary Baldev Singh, who in spite of being an NRI is very strict about adherence to Indian values. Simran has left for India to be married to her childhood fiancé. Raj leaves for India with a mission at his hands, to claim his lady love under the noses of her whole family. Thus begins a saga.",
            "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker."
        ][index]
    }

}
