import Foundation

public enum HttpMethod {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
}

extension String {
    var pathSegments: [String] {
        return self.componentsSeparatedByString("/").filter { $0 != "" }
    }
}

public func == (lhs: Route, rhs: Route) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public struct Route: Hashable {
    let method: HttpMethod
    let segments: [String]
    
    public var hashValue: Int {
        return "\(method)\(segments)".hashValue
    }
    
    public init(_ method: HttpMethod, path: String) {
        self.method = method
        self.segments = path.pathSegments
    }
    
    func match(method: HttpMethod, uri: String) -> Bool {
        if self.method != method {
            return false
        }
        
        let segments = uri.pathSegments
        
        if self.segments.count != segments.count {
            return false
        }
        
        for index in 0..<self.segments.count {
            if self.segments[index].characters.first != ":"
                && self.segments[index] != segments[index] {
                    return false
            }
        }
        
        return true
    }
}