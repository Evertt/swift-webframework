public class Request {
    public let method: HttpMethod
    public let uri: String
    public var parameters = RouteParameters()
    
    public init(method: HttpMethod, uri: String) {
        self.method = method
        self.uri    = uri
    }
}