public class Router {
    var routes = [Route]()
    var pipeline = Pipeline()
    
    public func add(route: Route) {
        self.routes.append(route)
    }
    
    public func add(middleware: Middleware) {
        self.pipeline.append(middleware)
    }
    
    public func dispatch(request: Request) -> Response {
        var pipeline = Pipeline()
        
        for route in routes {
            if let parameters = route.match(request.method, request.path) {
                request.parameters += parameters
                pipeline += route.pipeline
            }
        }
        
        if pipeline.isEmpty {
            return Response(statusCode: 404)
        }
        
        do {
            return try run(request, through: self.pipeline + pipeline)
        } catch {
            let response = Response(statusCode: 500)
            response.body = String(error)
            return response
        }
    }
    
    func run(request: Request, through pipeline: Pipeline) throws -> Response {
        let response = Response()
        
        let start = pipeline.reverse().reduce({$1}, combine: self.buildPipeline)
        
        try start(request, response)
        
        return response
    }
    
    private func buildPipeline(next: Next, middleware: Middleware) -> Next {
        return { request, response in try middleware(request, response, next) }
    }
}