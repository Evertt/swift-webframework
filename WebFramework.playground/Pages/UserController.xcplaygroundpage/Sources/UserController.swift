import Foundation

public class UserController {
    let request: Request
    let response: Response
    let next: Next
    
    public init(_ request: Request, _ response: Response, _ next: Next) {
        self.request = request
        self.response = response
        self.next = next
    }

    public func show() {
        response.body.appendContentsOf("\(request.parameters)")
    }
}