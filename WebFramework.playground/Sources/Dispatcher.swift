import Foundation

class Dispatcher {
    let response = Response()
    
    func dispatch(pipeline: Pipeline, request: Request) throws -> Response {
        let start = pipeline.reverse().reduce({_, _ in}, combine: self.buildPipeline)
        
        try start(request, response)
        
        return response
    }
    
    internal func buildPipeline(next: Next, handler: Handler) -> Next {
        return { request, response in try handler(request, response, next) }
    }
}