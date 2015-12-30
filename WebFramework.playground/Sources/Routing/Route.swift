public struct Route {
    let method: HttpMethod
    let segments: [String]
    
    public init(_ method: HttpMethod, path: String) {
        self.method = method
        self.segments = path.pathSegments
    }
    
    func match(method: HttpMethod, _ uri: String) -> [String:String]? {
        var parameters = Parameters()
        
        if self.method != method {
            return nil
        }
        
        let segments = uri.pathSegments
        
        if self.segments.count != segments.count {
            return nil
        }
        
        for index in 0..<self.segments.count {
            if self.segments[index].characters.first == ":" {
                let i = self.segments[index].startIndex.advancedBy(1)
                let key = self.segments[index].substringFromIndex(i)
                parameters[key] = segments[index]
            } else if self.segments[index] != segments[index] {
                return nil
            }
        }
        
        return parameters
    }
}