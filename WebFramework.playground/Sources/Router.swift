import Foundation

public typealias Pipeline = [Handler]
public typealias Next     = (Request, Response) throws -> ()
public typealias Handler  = (Request, Response, Next) throws -> ()

public class Router {
    var routes = OrderedDictionary<Route, Pipeline>()
    
    public func add(route: Route, pipeline: Pipeline) {
        self.routes[route] = pipeline
    }
    
    public func match(method: HttpMethod, uri: String) -> (Route, Pipeline)? {
        for (route, pipeline) in routes {
            if route.matches(method, uri: uri) {
                return (route, pipeline)
            }
        }
        
        return nil
    }
    
    public func dispatch(request: Request) throws -> Response {
        let method = request.method, uri = request.uri, response = Response()
        
        guard let (_, pipeline) = match(method, uri: uri) else {
            response.statusCode = 404
            
            return response
        }
        
        let start = pipeline.reverse().reduce({_, _ in}, combine: self.buildPipeline)
        
        try start(request, response)
        
        return response
    }
    
    internal func buildPipeline(next: Next, handler: Handler) -> Next {
        return { request, response in try handler(request, response, next) }
    }
}