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

    public func dispatch(requestString: String) throws {
        var request = Request(request: requestString)
        
        guard let pipeline = self.router.match(&request) else {
            var response = Response()
            response.statusCode = 404
            return print(response)
        }
        
        let response = try dispatcher.run(request, through: self.pipeline + pipeline)

        print(response)
    }
}