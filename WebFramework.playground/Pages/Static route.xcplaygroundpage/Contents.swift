//: ## This demonstrates a simple static route with one handler
//: Open the debug area to see the result of the dispatched route

app.get("/users")
{
    request, response, _ in
    
    response.headers["Content-Type"] = "text/html"
    response.body = "<p>Hello You!</p>"
    
    return (request, response)
}

try app.dispatch("GET /users")

//: [Next](@next)
