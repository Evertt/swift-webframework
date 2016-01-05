public typealias Pipeline   = [Middleware]
public typealias Header     = (String,String)
public typealias Parameters = [String:String]
public typealias Next       = (Request) throws -> Response
public typealias Middleware = (Request, Next) throws -> Response

public enum HttpMethod: String {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
}

extension Array {
    func get(index: Int, orElse defaultValue: Element?) -> Element? {
        if self.count < index {
            return self[index]
        } else {
            return defaultValue
        }
    }
}

extension String {
    var pathSegments: [String] {
        return self.componentsSeparatedByString("/").filter { $0 != "" }
    }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    
    func substringFromAfterFirstOccurenceOf(string: String) -> String {
        let range = self.rangeOfString(string)
        
        return self.substringFromIndex(range?.endIndex ?? self.endIndex)
    }
    
    func makeDictionaryBySplittingOn(firstSeparator: String, and secondSeparator: String) -> [String:String] {
        var theDictionary = [String:String]()
        
        for a in self.componentsSeparatedByString(firstSeparator) {
            let b = a.componentsSeparatedByString(secondSeparator)
            
            if b.count != 2 { break }
            
            theDictionary[b[0]] = b[1]
        }
        
        return theDictionary
    }
}

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

public let app = Application()