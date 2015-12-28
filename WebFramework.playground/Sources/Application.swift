import Foundation

public class Application {
    let router = Router()
    
    public func get(path: String, _ pipeline: Handler...) {
        router.add(Route(.GET, path: path), pipeline: pipeline)
    }
    
    public func post(path: String, _ pipeline: Handler...) {
        router.add(Route(.POST, path: path), pipeline: pipeline)
    }
    
    public func put(path: String, _ pipeline: Handler...) {
        router.add(Route(.PUT, path: path), pipeline: pipeline)
    }

    public func dispatch(method: HttpMethod, uri: String) throws {
        let request = Request(method: method, uri: uri)
        let response = try router.dispatch(request)

        print(response)
    }
}

public let app = Application()