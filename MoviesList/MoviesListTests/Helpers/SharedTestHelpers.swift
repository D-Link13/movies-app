import Foundation

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    try! JSONSerialization.data(withJSONObject: ["results": items])
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

extension HTTPURLResponse {
    
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
