class Dispatcher {
    func run(request: Request, through pipeline: Pipeline) throws -> Response {
        let response = Response()
        
        let start = pipeline.reverse().reduce({$1}, combine: self.buildPipeline)
        
        try start(request, response)
        
        return response
    }
    
    internal func buildPipeline(next: Next, middleware: Middleware) -> Next {
        return { request, response in try middleware(request, response, next) }
    }
}