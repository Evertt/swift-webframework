import Foundation

public class Request {
    public let path: String
    public let body: String
    public let version: String
    public let headers: [Header]
    public let query: Parameters
    public let method: HttpMethod
    public var parameters = Parameters()
    
    public init(request: String) {
        let scanner = NSScanner(string: request)
        
        method = HttpMethod(rawValue: scanner.scanUpToString(" ")!) ?? .GET
        let uri = scanner.scanUpToString(" ")!.componentsSeparatedByString("?")
        version = scanner.scanUpToString("\r\n") ?? ""
        
        let r = request.substringFromAfterFirstOccurenceOf("\r\n")
        path = uri[0]
        query = uri.get(1, orElse: "")!.makeDictionaryBySplittingOn("&", and: "=")
        headers = r.makeDictionaryBySplittingOn("\r\n", and: ": ").map{$0}
        body = r.substringFromAfterFirstOccurenceOf("\r\n\r\n")
    }
}