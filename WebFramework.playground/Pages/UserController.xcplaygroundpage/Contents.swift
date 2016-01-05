//: [Previous](@previous)
app.get("/users/:name") {
    try UserController($0, $1).show()
}

app.dispatch("GET /users/evert")
//: [Next](@next)
