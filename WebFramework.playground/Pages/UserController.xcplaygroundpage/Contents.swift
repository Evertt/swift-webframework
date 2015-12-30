//: [Previous](@previous)

app.get("/users/:name") {
    UserController($0,$1,$2).show()
}

try app.dispatch("GET /users/evert")
//: [Next](@next)
