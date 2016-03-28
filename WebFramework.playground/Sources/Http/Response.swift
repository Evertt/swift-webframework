public enum HttpStatus : String {
    case OK = "200 OK"
    case Created = "201 Created"
    case Accepted = "202 Accepted"
    
    case MultipleChoices = "300 Multiple Choices"
    case MovedPermanently = "301 Moved Permanently"
    case Found = "302 Found"
    case SeeOther = "303 See Other"
    
    case BadRequest = "400 Bad Request"
    case Unauthorized = "401 Unauthorized"
    case Forbidden = "403 Forbidden"
    case NotFound = "404 Not Found"
    
    case InternalServerError = "500 Internal Server Error"
    case BadGateway = "502 Bad Gateway"
    case ServiceUnavailable = "503 Service Unavailable"
}

public struct Response: CustomStringConvertible {
    public let status: HttpStatus
    public let headers: [Header]
    public let body: String
    public var statusLine: String {
        return status.rawValue
    }
    
    public init(status: HttpStatus = .OK, body: String = "", headers: [Header] = []) {
        self.status = status
        self.headers = headers
        self.body = body
    }
    
    public func withStatus(status: HttpStatus) -> Response {
        return Response(status: status, body: body, headers: headers)
    }
    
    public func withHeader(key: String, _ value: String) -> Response {
        let headers = self.headers + [(key, value)]
        
        return Response(status: status, body: body, headers: headers)
    }
    
    public func withBody(body: String) -> Response {
        return Response(status: status, body: "\(self.body)\n\(body)", headers: headers)
    }
    
    public func appendToBody(appendix: String) -> Response {
        return Response(status: status, body: body + appendix, headers: headers)
    }
    
    public func withHtml(value: String) -> Response {
        return withHeader("Content-Type", "text/html").withBody(value)
    }
    
    public func withText(value: String) -> Response {
        return withHeader("Content-Type", "plain/text").withBody(value)
    }
    
    public var description: String {
        return
            "HTTP/1.1 \(statusLine)\n" +
            headers.reduce("", combine: {"\($0)\($1.0): \($1.1)\n"}) +
            "\n\(body)"
    }
}