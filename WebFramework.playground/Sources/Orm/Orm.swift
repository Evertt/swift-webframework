public protocol Entity {
    init()
}

public protocol Repository {
    init(orm: Orm)
}

public protocol Orm {
    init(entityType: Entity.Type)
    
    func find(id: Int) -> Entity
}

public class FakeOrm: Orm {
    let entityType: Entity.Type
    
    required public init(entityType: Entity.Type) {
        self.entityType = entityType
    }
    
    public func find(id: Int) -> Entity {
        return entityType.init()
    }
}