//: [Previous](@previous)
//: ## This demonstrates a simple route with one dynamic parameter and with one handler

app.put("/users/{year:\\d+}?-{month:\\d+}?-{day:\\d+}?")
{
    request, next in let response = try next(request)
    
    return response.withText(request.parameters.description)
}

app.dispatch("PUT /users/1990-03")

//: [Next](@next)
