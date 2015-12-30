public class Application {
    let router = Router()
    var pipeline = Pipeline()
    let dispatcher = Dispatcher()
    
    public func add(middleware: Middleware) {
        self.pipeline.append(middleware)
    }
    
    public func get(path: String, _ pipeline: Middleware...) {
        router.add(Route(.GET, path: path), pipeline: pipeline)
    }
    
    public func post(path: String, _ pipeline: Middleware...) {
        router.add(Route(.POST, path: path), pipeline: pipeline)
    }
    
    public func put(path: String, _ pipeline: Middleware...) {
        router.add(Route(.PUT, path: path), pipeline: pipeline)
    }

    public func dispatch(requestString: String) throws {
        let request = Request(request: requestString)
        
        guard let pipeline = self.router.match(request) else {
            return print(Response(statusCode: 404))
        }
        
        let response = try dispatcher.run(request, through: self.pipeline + pipeline)

        print(response)
    }
}