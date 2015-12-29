import Foundation

public typealias Middleware = Handler
public typealias Pipeline   = [Handler]
public typealias Next       = (Request, Response) throws -> ()
public typealias Handler    = (Request, Response, Next) throws -> ()

public enum HttpMethod {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
}

extension String {
    var pathSegments: [String] {
        return self.componentsSeparatedByString("/").filter { $0 != "" }
    }
}

public let app = Application()