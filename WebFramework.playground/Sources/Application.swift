import Foundation

public typealias Middleware = Handler
public typealias Pipeline   = [Handler]
public typealias Next       = (Request, Response) throws -> ()
public typealias Handler    = (Request, Response, Next) throws -> ()

public class Application {
    let router = Router()
    var pipeline = Pipeline()
    let dispatcher = Dispatcher()
    
    public func add(middleware: Middleware) {
        self.pipeline.append(middleware)
    }
    
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
        
        guard let pipeline = self.router.match(method, uri) else {
            let response = Response()
            response.statusCode = 404
            return print(response)
        }
        
        let response = try dispatcher.run(request, through: self.pipeline + pipeline)

        print(response)
        
        response.clear()
    }
}

public let app = Application()