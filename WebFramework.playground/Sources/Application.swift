public class Application {
    let router = Router()
    
    public func add(middleware: Middleware) {
        router.add(middleware)
    }
    
    public func get(path: String, _ pipeline: Middleware...) {
        router.add(Route(.GET, path: path, pipeline: pipeline))
    }
    
    public func post(path: String, _ pipeline: Middleware...) {
        router.add(Route(.POST, path: path, pipeline: pipeline))
    }
    
    public func put(path: String, _ pipeline: Middleware...) {
        router.add(Route(.PUT, path: path, pipeline: pipeline))
    }

    public func dispatch(requestString: String) {
        let request = Request(request: requestString)

        print(router.dispatch(request))
    }
}