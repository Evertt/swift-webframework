import Foundation

public class User: Entity {
    let id: Int
    let name: String
    
    required public init() {
        id = 1
        name = "John Doe"
    }
}