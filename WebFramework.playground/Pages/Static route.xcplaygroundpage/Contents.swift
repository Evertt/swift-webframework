//: ## This demonstrates a simple static route with one handler
//: Open the debug area to see the result of the dispatched route

app.get("/users")
{
    request, next in let response = try next(request)
    
    return response.withHtml("<p>Hello You!</p>")
}

app.dispatch("GET /users")

//: [Next](@next)
