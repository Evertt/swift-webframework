//: [Previous](@previous)
//: ## This demonstrates how you can add middleware globally, to all routes

var globalMiddleware: Middleware = {
    request, response, next in
    
    response.headers["Content-Type"] = "text/html"
    
    response.body.appendContentsOf("Content prepended to body by middleware...\n")
    
    try next(request, response)
    
    response.body.appendContentsOf("\nContent appended to body by middleware...")
}

app.add(globalMiddleware)

app.get("/users",
    {
        _, response, _ in
        
        response.body.appendContentsOf("This route has middleware")
    }
)

app.get("/users/:id",
    {
        _, response, _ in
        
        response.body.appendContentsOf("And this one too")
    }
)

try app.dispatch(HttpMethod.GET, uri: "/users")

print("\n--------------NEXT--REQUEST--------------\n")

try app.dispatch(HttpMethod.GET, uri: "/users/1")
