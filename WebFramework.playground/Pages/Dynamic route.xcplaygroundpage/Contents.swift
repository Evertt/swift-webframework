//: [Previous](@previous)
//: ## This demonstrates a simple route with one dynamic parameter and with one handler

app.put("/users/:id")
{
    request, response, _ in
    
    response.body = "id = " + request.parameters["id"]!
}

try app.dispatch("PUT /users/2")

//: [Next](@next)
