import Foundation

public class Request {
    public let path: String
    public let body: String
    public let version: String
    public let headers: [Header]
    public let query: Parameters
    public let method: HttpMethod
    public var parameters = Parameters()
    
    public init(var request: String) {
        let scanner = NSScanner(string: request)
        
        method = HttpMethod(rawValue: scanner.scanUpToString(" ")!) ?? .GET
        let uri = scanner.scanUpToString(" ")!.componentsSeparatedByString("?")
        version = scanner.scanUpToString("\r\n") ?? ""
        
        request = request.substringFromAfterFirstOccurenceOf("\r\n")
        path = uri[0]
        query = uri.get(1, orElse: "")!.makeDictionaryBySplittingOn("&", and: "=")
        headers = request.makeDictionaryBySplittingOn("\r\n", and: ": ").map{$0}
        body = request.substringFromAfterFirstOccurenceOf("\r\n\r\n")
    }
}