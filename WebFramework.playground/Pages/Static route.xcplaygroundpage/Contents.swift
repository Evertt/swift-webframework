//: ## This demonstrates a simple static route with one handler
//: Open the debug area to see the result of the dispatched route

//app.get("/users")
//{
//    request, next in let response = try next(request)
//    
//    return response.withHtml("<p>Hello You!</p>")
//}
//
//app.dispatch("GET /users")

struct UserDied: Event {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class UserWasBorn: Event {
    let year: Int
    
    init(year: Int) {
        self.year = year
    }
}

func anyArrayToType<T>(anyArray: [Any]) -> [T] {
    return anyArray.flatMap {
        if let integer = $0 as? T {
            return integer
        }
        
        return nil
    }
}

let daveDied = UserDied(name: "Dave")
let bartWasBorn = UserWasBorn(year: 2000)

var events = MyDispatcher()

events.listen {
    (event: UserDied) -> Int in
    
    print("1st was called")
    //events.stopPropagating(event)
    
    return 5
}

events.listen {
    (event: UserDied) -> Void in
    
    print("2nd was called")
}

events.listen {
    (event: UserDied) -> String? in
    
    print("3rd was called")
    
    if event.name == "Dave" {
        return event.name + "?"
    }
    
    return nil
}

events.listen {
    (event: UserDied) -> Int in
    
    print("4th was called")
    
    return 32
}

events.listen {
    (event: UserWasBorn) in
    
    print(event.year)
}

print(events.fire(daveDied) as [Any])
//events.fire(daveDied, shouldObeyHalt: true)
//events.queue(UserWasBorn(year: 1990))
//events.queue(UserWasBorn(year: 2013))
//events.queue(UserDied(name: "Evert"))
//events.flushQueue()
//print(daveDied.name)

//: [Next](@next)
