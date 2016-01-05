import Foundation

public class UserController {
    let request: Request
    let next: Next
    
    public init(_ request: Request, _ next: Next) {
        self.request = request
        self.next = next
    }

    public func show() throws -> Response {
        return try next(request).withText("\(request.parameters)")
    }
}