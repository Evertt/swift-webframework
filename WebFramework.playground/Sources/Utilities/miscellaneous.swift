import Foundation

public typealias Pipeline   = [Middleware]
public typealias Header     = (String,String)
public typealias Parameters = [String:String]
public typealias Next       = (Request) throws -> Response
public typealias Middleware = (Request, Next) throws -> Response

public enum HttpMethod: String {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
}

extension Array {
    func get(index: Int, orElse defaultValue: Element? = nil) -> Element? {
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
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> Character {
        get {
            return self[self.startIndex.advancedBy(i)]
        }
        set(newChar) {
            self.insert(newChar, atIndex: self.startIndex.advancedBy(i))
        }
    }
    
    subscript (i: Int) -> String {
        get {
            return String(self[i] as Character)
        }
        set(newString) {
            self.insertContentsOf(newString.characters, at: startIndex.advancedBy(i))
        }
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            return substringWithRange(startIndex.advancedBy(r.startIndex)..<startIndex.advancedBy(r.endIndex))
        }
        set(newValue) {
            let beginning = substringWithRange(startIndex..<startIndex.advancedBy(r.startIndex))
            let ending = substringWithRange(startIndex.advancedBy(r.endIndex)...endIndex)
            self = beginning + newValue + ending
        }
    }
    
    mutating func removeRange(subRange: Range<Int>) {
        removeRange(startIndex.advancedBy(subRange.startIndex)..<startIndex.advancedBy(subRange.endIndex))
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
    
    func getMatches(regex: String, options: NSRegularExpressionOptions = NSRegularExpressionOptions()) throws -> [NSTextCheckingResult] {
        let exp = try NSRegularExpression(pattern: regex, options: options)
        let matches = exp.matchesInString(self, options: NSMatchingOptions(), range: NSMakeRange(0, self.length))
        return matches as [NSTextCheckingResult]
    }
}

extension Dictionary {
    init(keys: [Key], values: [Value]) {
        self.init()
        
        for (key, value) in zip(keys, values) {
            self[key] = value
        }
    }
}

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

public let app = Application()