import Foundation

public class Router {
    var routes = OrderedDictionary<Route, Pipeline>()
    
    public func add(route: Route, pipeline: Pipeline) {
        self.routes[route] = pipeline
    }
    
    public func match(method: HttpMethod, uri: String) -> (Pipeline, [Any])? {
        for (route, pipeline) in routes {
            if let parameters = route.match(method, uri: uri) {
                return (pipeline, parameters)
            }
        }
        
        return nil
    }
}