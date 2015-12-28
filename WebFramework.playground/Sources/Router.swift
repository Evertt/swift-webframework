import Foundation

public typealias Middleware = Handler
public typealias Pipeline   = [Handler]
public typealias Next       = (Request, Response) throws -> ()
public typealias Handler    = (Request, Response, Next) throws -> ()

public class Router {
    var routes = OrderedDictionary<Route, Pipeline>()
    
    public func add(route: Route, pipeline: Pipeline) {
        self.routes[route] = pipeline
    }
    
    public func match(method: HttpMethod, uri: String) -> Pipeline? {
        for (route, pipeline) in routes {
            if route.matches(method, uri: uri) {
                return pipeline
            }
        }
        
        return nil
    }
}