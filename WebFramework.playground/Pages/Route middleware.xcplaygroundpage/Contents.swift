//: [Previous](@previous)
//: ## This demonstrates how you can add middleware to specific routes

var routeMiddleware: Middleware = {
    (var request, var response, next) in
    
    response.headers["Content-Type"] = "text/html"
    
    response.body.appendContentsOf("Content prepended to body by middleware...\n")
    
    (request, response) = try next(request, response)
    
    response.body.appendContentsOf("\nContent appended to body by middleware...")
    
    return (request, response)
}

app.get("/users",
    {
        request, response, _ in
        
        response.body.appendContentsOf("This route doesn't have middleware")
        
        return (request, response)
    }
)

app.get("/users/:id",
    routeMiddleware, // <-- Look here the middleware is added
    {
        request, response, _ in
        
        response.body.appendContentsOf("This route has middleware")
        
        return (request, response)
    }
)

try app.dispatch(HttpMethod.GET, uri: "/users")

print("\n--------------NEXT--REQUEST--------------\n")

try app.dispatch(HttpMethod.GET, uri: "/users/1")

//: [Next](@next)
