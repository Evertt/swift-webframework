//: [Previous](@previous)
//: ## This demonstrates how you can add middleware to specific routes

var routeMiddleware: Middleware = {
    request, next in let response = try next(request)
    
    return response.appendToBody("\nContent appended to body by middleware...")
}

app.get("/users",
    {
        request, next in let response = try next(request)
        
        return response.withHtml("This route doesn't have middleware")
    }
)

app.get("/users/:id",
    routeMiddleware, // <-- Look here the middleware is added
    {
        request, next in let response = try next(request)
        
        return response.withHtml("This route has middleware")
    }
)

app.dispatch("GET /users")

print("\n--------------NEXT--REQUEST--------------\n")

app.dispatch("GET /users/1")

//: [Next](@next)
