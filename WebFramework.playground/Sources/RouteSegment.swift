import Foundation

public enum ParsingError : ErrorType {
    case MissingParameterName
}

protocol RouteSegment {
    init(pathSegment: String) throws
    
    func matches(uriSegment: String) -> Bool
    func isEqualTo(other: RouteSegment) -> Bool
    func getParameter(uriSegment: String) -> Any?
}

extension Equatable where Self : RouteSegment {
    func isEqualTo(other: RouteSegment) -> Bool {
        guard let o = other as? Self else { return false }
        return self == o
    }
}

/// A dynamic route segment represents the `{id:[0-9]+}` in `/users/{id:[0-9]+}`
struct DynamicRouteSegment : RouteSegment, Equatable {
    let name: String
    let type: String
    let optional: Bool
    var parameter: String? = nil
    
    init(pathSegment: String) throws {
        var type: String?
        let scanner = NSScanner(string: pathSegment)
        let chars = NSCharacterSet(charactersInString: ":}")
        
        scanner.scanString("{")
        
        guard let name = scanner.scanUpToCharactersFromSet(chars) else {
            throw ParsingError.MissingParameterName
        }
        
        if scanner.scanString(":") != nil {
            type = scanner.scanUpToString("}")
        }
        
        scanner.scanString("}")
        
        self.name = name
        self.type = type ?? "[^/]"
        self.optional = scanner.scanString("?") != nil
    }
    
    func matches(uriSegment: String) -> Bool {
        if uriSegment.match(self.type) {
            return true
        }
        
        if uriSegment == "" {
            return self.optional
        }
        
        return false
    }
    
    func getParameter(uriSegment: String) -> Any? {
        return self.parameter
    }
}

func == (lhs: DynamicRouteSegment, rhs: DynamicRouteSegment) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type && lhs.optional == rhs.optional
}

/// A static route segment represents the `users` in `/users/{id:[0-9]+}`
struct StaticRouteSegment : RouteSegment, Equatable {
    let routeSegment: String
    
    init(pathSegment: String) {
        self.routeSegment = pathSegment
    }
    
    func matches(uriSegment: String) -> Bool {
        return self.routeSegment == uriSegment
    }
    
    func getParameter(uriSegment: String) -> Any? {
        return nil
    }
}

func == (lhs: StaticRouteSegment, rhs: StaticRouteSegment) -> Bool {
    return lhs.routeSegment == rhs.routeSegment
}