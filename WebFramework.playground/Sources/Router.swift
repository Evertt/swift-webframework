import Foundation

public class Router {
    var routes = [(Route, Pipeline)]()
    
    public func add(route: Route, pipeline: Pipeline) {
        self.routes.append((route, pipeline))
    }
    
    public func match(method: HttpMethod, _ uri: String) -> Pipeline? {
        for (route, pipeline) in routes {
            if route.match(method, uri) {
                return pipeline
            }
        }
        
        return nil
    }
}