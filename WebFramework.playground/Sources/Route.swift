import Foundation

public enum HttpMethod {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
}

public struct Route : Hashable {
    let method: HttpMethod
    let segments: [RouteSegment]
    
    public var hashValue: Int {
        return "\(method) \(segments)".hashValue
    }
    
    public init(_ method: HttpMethod, path: String) {
        let pathSegments = path.componentsSeparatedByString("/").filter { $0 != "" }
        var routeSegments: [RouteSegment] = []
        
        for pathSegment in pathSegments {
            if pathSegment[pathSegment.startIndex] == "{" {
                routeSegments.append(
                    (try? DynamicRouteSegment(pathSegment: pathSegment))
                    ?? StaticRouteSegment(pathSegment: pathSegment)
                )
            } else {
                routeSegments.append(StaticRouteSegment(pathSegment: pathSegment))
            }
        }
        
        self.method   = method
        self.segments = routeSegments
    }
    
    func match(method: HttpMethod, uri: String) -> [Any]? {
        var parameters = [Any]()
        if (method != self.method) { return nil }
        
        let uriSegments = uri.componentsSeparatedByString("/").filter { $0 != "" }
        
        for (index, segment) in uriSegments.enumerate() {
            if (index >= self.segments.count) {
                return nil
            }
            
            if self.segments[index].matches(segment) == false {
                return nil
            }
            
            if let parameter = self.segments[index].getParameter(segment) {
                parameters.append(parameter)
            }
        }
        
        return parameters
    }
}

func == (lhs: [RouteSegment], rhs: [RouteSegment]) -> Bool {
    return lhs.count == rhs.count && !zip(lhs, rhs).contains { !$0.isEqualTo($1) }
}

public func == (lhs: Route, rhs: Route) -> Bool {
    return lhs.method == rhs.method && lhs.segments == rhs.segments
}