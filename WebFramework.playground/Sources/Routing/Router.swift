public class Router {
    var routes = [(Route, Pipeline)]()
    
    public func add(route: Route, pipeline: Pipeline) {
        self.routes.append((route, pipeline))
    }
    
    public func match(request: Request) -> Pipeline? {
        for (route, pipeline) in routes {
            if let parameters = route.match(request.method, request.path) {
                request.parameters = parameters
                
                return pipeline
            }
        }
        
        return nil
    }
}