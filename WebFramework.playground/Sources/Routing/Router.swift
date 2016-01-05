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
            return Response(status: .NotFound)
        }
        
        do {
            return try run(request, through: self.pipeline + pipeline)
        } catch {
            return Response(status: .InternalServerError, body: String(error))
        }
    }
    
    func run(request: Request, through pipeline: Pipeline) throws -> Response {
        let start = pipeline.reverse().reduce({_ in Response()}, combine: buildPipeline)
        
        return try start(request)
    }
    
    private func buildPipeline(next: Next, middleware: Middleware) -> Next {
        return { request in try middleware(request, next) }
    }
}