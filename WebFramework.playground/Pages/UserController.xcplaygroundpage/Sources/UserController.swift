import Foundation

public class UserController {
    let request: Request
    let next: Next
    let users: UserRepository
    
    public init(_ request: Request, _ next: Next, users: UserRepository) {
        self.request = request
        self.next = next
        self.users = users
    }

    public func show() throws -> Response {
        print(users[1].name)
        return try next(request).withText("\(request.parameters)")
    }
}