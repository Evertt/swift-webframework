import Foundation

public enum ParsingError : ErrorType {
    case MissingParameterName
}

protocol RouteSegment {
    init(pathSegment: String) throws
    
    func matches(uriSegment: String) -> Bool
    func isEqualTo(other: RouteSegment) -> Bool
}

extension Equatable where Self : RouteSegment {
    func isEqualTo(other: RouteSegment) -> Bool {
        guard let o = other as? Self else { return false }
        return self == o
    }
}

struct DynamicRouteSegment : RouteSegment, Equatable {
    let name: String
    let type: String
    let optional: Bool
    
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
        return true
    }
}

func == (lhs: DynamicRouteSegment, rhs: DynamicRouteSegment) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type && lhs.optional == rhs.optional
}

struct StaticRouteSegment : RouteSegment, Equatable {
    let routeSegment: String
    
    init(pathSegment: String) {
        self.routeSegment = pathSegment
    }
    
    func matches(uriSegment: String) -> Bool {
        return self.routeSegment == uriSegment
    }
}

func == (lhs: StaticRouteSegment, rhs: StaticRouteSegment) -> Bool {
    return lhs.routeSegment == rhs.routeSegment
}