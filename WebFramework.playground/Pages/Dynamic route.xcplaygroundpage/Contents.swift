//: [Previous](@previous)
//: ## This demonstrates a simple route with one dynamic parameter and with one handler

app.put("/users/:id")
{
    _, response, _ in
        
    response.body = "For this demo I didn't " +
                    "make it possible yet to get " +
                    "the value of the route parameter"
}

try app.dispatch(.PUT, uri: "/users/1")

//: [Next](@next)
