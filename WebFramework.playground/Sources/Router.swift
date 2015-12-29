import Foundation

public class Router {
    var routes = OrderedDictionary<Route, Pipeline>()
    
    public func add(route: Route, pipeline: Pipeline) {
        self.routes[route] = pipeline
    }
    
    public func match(method: HttpMethod, uri: String) -> Pipeline? {
        for (route, pipeline) in routes {
            if route.match(method, uri: uri) {
                return pipeline
            }
        }
        
        return nil
    }
}