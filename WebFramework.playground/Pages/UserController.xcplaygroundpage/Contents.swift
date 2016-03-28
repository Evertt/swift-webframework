//: [Previous](@previous)
app.get("/users/{name}") {
    request, next in
    
    let fakeOrm = FakeOrm(entityType: User.self)
    let users = UserRepository(orm: fakeOrm)
    
    return try UserController(request, next, users: users).show()
}

app.dispatch("GET /users/evert")
//: [Next](@next)
