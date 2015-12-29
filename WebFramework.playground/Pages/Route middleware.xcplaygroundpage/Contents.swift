//: [Previous](@previous)

app.get("/users",
    {
        _, response, _ in
        
        response.body.appendContentsOf("This route doesn't have middleware")
    }
)

var routeMiddleware: Middleware = {
    request, response, next in
    
    response.headers["Content-Type"] = "text/html"
    
    response.body.appendContentsOf("Content prepended to body by middleware...\n")
    
    try next(request, response)
    
    response.body.appendContentsOf("\nContent appended to body by middleware...")
}

app.get("/users/:id",
    routeMiddleware,
    {
        _, response, _ in
        
        response.body.appendContentsOf("This route has middleware")
    }
)

try app.dispatch(HttpMethod.GET, uri: "/users")

print("\n--------------NEXT--REQUEST--------------\n")

try app.dispatch(HttpMethod.GET, uri: "/users/1")

//: [Next](@next)