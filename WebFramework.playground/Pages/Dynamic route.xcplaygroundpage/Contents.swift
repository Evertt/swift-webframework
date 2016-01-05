//: [Previous](@previous)
//: ## This demonstrates a simple route with one dynamic parameter and with one handler

app.put("/users/:id")
{
    request, next in let response = try next(request)
    
    return response.withText("id = " + request.parameters["id"]!)
}

app.dispatch("PUT /users/2")

//: [Next](@next)
