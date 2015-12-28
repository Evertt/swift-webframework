import Foundation

struct Regex: StringLiteralConvertible {
    var pattern: String {
        didSet {
            updateRegex()
        }
    }
    var expressionOptions: NSRegularExpressionOptions {
        didSet {
            updateRegex()
        }
    }
    var matchingOptions: NSMatchingOptions
    
    var regex: NSRegularExpression?
    
    init(pattern: String,
        expressionOptions: NSRegularExpressionOptions = NSRegularExpressionOptions(),
        matchingOptions: NSMatchingOptions = NSMatchingOptions()
        ) {
            self.pattern = pattern
            self.expressionOptions = expressionOptions
            self.matchingOptions = matchingOptions
            updateRegex()
    }
    
    mutating func updateRegex() {
        regex = try? NSRegularExpression(pattern: pattern, options: expressionOptions)
    }
    
    init(stringLiteral: String) {
        self.init(pattern: stringLiteral)
    }
    init(extendedGraphemeClusterLiteral: String) {
        self.init(pattern: extendedGraphemeClusterLiteral)
    }
    init(unicodeScalarLiteral: String) {
        self.init(pattern: unicodeScalarLiteral)
    }
}


extension String {
    func matchRegex(pattern: Regex) -> Bool {
        let range = NSRange(location: 0, length: characters.startIndex.distanceTo(endIndex))
        guard let regex = pattern.regex else { return false }
        return !regex.matchesInString(self, options: pattern.matchingOptions, range: range).isEmpty
    }
    
    func match(patternString: String) -> Bool {
        return self.matchRegex(Regex(pattern: patternString))
    }
    
    func replaceRegex(pattern: Regex, template: String) -> String {
        guard matchRegex(pattern), let regex = pattern.regex else { return self }
        let range = NSRange(location: 0, length: characters.startIndex.distanceTo(endIndex))
        return regex.stringByReplacingMatchesInString(self, options: pattern.matchingOptions, range: range, withTemplate: template)
    }
    
    func replace(pattern: String, template: String) -> String {
        return self.replaceRegex(Regex(pattern: pattern), template: template)
    }
}