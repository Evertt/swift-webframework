import Foundation

class Dispatcher {
    func run(request: Request, through pipeline: Pipeline) throws -> Response {
        let response = Response()
        
        let start = pipeline.reverse().reduce({$0}, combine: self.buildPipeline)
        
        try start(request, response)
        
        return response
    }
    
    internal func buildPipeline(next: Next, handler: Handler) -> Next {
        return { request, response in try handler(request, response, next) }
    }
}