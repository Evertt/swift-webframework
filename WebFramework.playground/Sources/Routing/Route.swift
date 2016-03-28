import Foundation

public struct Route {
    let method: HttpMethod
    let pipeline: Pipeline
    var parameterNames = [String]()
    var routeRegex = NSRegularExpression()
    
    public init(_ method: HttpMethod, path: String, pipeline: Pipeline) {
        self.method = method
        self.pipeline = pipeline
        self.routeRegex = try! disectRoute(path)
    }
    
    mutating func disectRoute(route: String) throws -> NSRegularExpression {
        let pattern = "\\{(\\w+?)(?::((?:[^{}]|\\\\\\{|\\\\\\}|\\{.*?\\})+?))?\\}(\\?)?|([^{}]+)"
        
        func getLastChars(inout str: String) -> String {
            var i = str.endIndex.predecessor()
            var res = String(str.removeAtIndex(i))
            i = i.predecessor()
            
            if str[i] == "\\" && str[i.predecessor()] != "\\" {
                res.append(str.removeAtIndex(i))
                res = String(res.characters.reverse())
            }
            
            return res
        }
        
        func extractMatch(result: String, match: NSTextCheckingResult) throws -> (String) {
            if let uriRange = match.rangeAtIndex(4).toRange() {
                return result + NSRegularExpression.escapedPatternForString(route[uriRange])
            }
            
            var res = result
            var regex: String
            parameterNames += [route[match.rangeAtIndex(1).toRange()!]]
            
            if let typeRange = match.rangeAtIndex(2).toRange() {
                regex = "(?:\(route[typeRange]))"
            } else {
                regex = "(?:[^/]+)"
            }
            
            let optional = match.rangeAtIndex(3).toRange() != nil
            
            if optional {
                let last = getLastChars(&res)
                regex = "\(last)?(\(regex)?)"
            } else {
                regex = "(\(regex))"
            }
            
            return res + regex
        }
        
        let routePattern = try route.getMatches(pattern).reduce("", combine: extractMatch)
        
        return try NSRegularExpression(pattern: "^\\/?\(routePattern)\\/?$", options: .CaseInsensitive)
    }
    
    func match(method: HttpMethod, _ url: String) -> Parameters? {
        var parameters = Parameters()
        
        guard let match = routeRegex.firstMatchInString(url, options: .Anchored, range: NSMakeRange(0, url.length)) else {
            return nil
        }
        
        for i in 1..<match.numberOfRanges {
            parameters[parameterNames[i-1]] = url[match.rangeAtIndex(i).toRange()!]
        }
        
        return parameters
    }
}