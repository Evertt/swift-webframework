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
        request, response, next in
        
        response.body.appendContentsOf("And this one too")
        
        // This line doesn't have any effect,
        // because this is the last handler.
        // I just wanted to show that it
        // doesn't break anything if it's here.
        try next(request, response)
    }
)

try app.dispatch("GET /users")

print("\n--------------NEXT--REQUEST--------------\n")

try app.dispatch("GET /users/1")
