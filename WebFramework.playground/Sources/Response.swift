public class Response: CustomStringConvertible {
    public var statusCode = 200
    public var headers = [String:String]()
    public var body = String()
    internal let httpStatuses = [
        200: "OK",
        201: "Created",
        202: "Accepted",
        
        300: "Multiple Choices",
        301: "Moved Permanently",
        302: "Found",
        303: "See other",
        
        400: "Bad Request",
        401: "Unauthorized",
        403: "Forbidden",
        404: "Not Found",
        
        500: "Internal Server Error",
        502: "Bad Gateway",
        503: "Service Unavailable"
    ]
    
    public var description: String {
        return
            "HTTP/1.0 \(statusCode) \(httpStatuses[statusCode]!)\n" +
            headers.reduce("", combine: {"\($0)\($1.0): \($1.1)\n"}) +
            "\n\(body)"
    }
}