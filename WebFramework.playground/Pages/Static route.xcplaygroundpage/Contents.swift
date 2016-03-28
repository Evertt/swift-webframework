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
}

class UserWasBorn: Event {
    let year: Int
    
    init(year: Int) {
        self.year = year
    }
}

let daveDied = UserDied(name: "Dave")
let bartWasBorn = UserWasBorn(year: 2000)

var events = MyDispatcher()

events.listen {
    (event: UserDied) in
    
    return 5
}

events.listen {
    (event: UserDied) in
    
    print(event.name + "!")
}

events.listen {
    (event: UserDied) in
    
    return event.name + "?"
}

events.listen {
    (event: UserWasBorn) in
    
    print(event.year)
}

print(events.fire(daveDied))
//events.queue(UserWasBorn(year: 1990))
//events.queue(UserWasBorn(year: 2013))
//events.queue(UserDied(name: "Evert"))
//events.flushQueue()
//print(daveDied.name)

//: [Next](@next)
