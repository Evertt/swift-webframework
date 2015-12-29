//: [Previous](@previous)
//: ## This demonstrates a simple route with one dynamic parameter and with one handler

app.put("/users/:id")
{
    (request, var response, _) in
    
    response.body = String(request.parameters)
    
    return (request, response)
}

try app.dispatch("PUT /users/2")

//: [Next](@next)
