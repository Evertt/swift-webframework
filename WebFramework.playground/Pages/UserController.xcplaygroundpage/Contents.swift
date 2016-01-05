//: [Previous](@previous)
app.get("/users/:name") {
    UserController($0,$1,$2).show()
}

app.dispatch("GET /users/evert")
//: [Next](@next)
