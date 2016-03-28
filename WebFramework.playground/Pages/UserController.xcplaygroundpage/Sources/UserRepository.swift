import Foundation

public class UserRepository: Repository {
    let orm: Orm
    
    required public init(orm: Orm) {
        self.orm = orm
    }
    
    subscript(id: Int) -> User {
        return orm.find(id) as! User
    }
}