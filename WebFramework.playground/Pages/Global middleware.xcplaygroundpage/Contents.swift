//: [Previous](@previous)
//: ## This demonstrates how you can add middleware globally, to all routes

var globalMiddleware: Middleware = {
    request, next in let response = try next(request)
    
    return response.appendToBody("\nContent appended to body by middleware...")
}

app.add(globalMiddleware)

app.get("/users",
    {
        request, next in let response = try next(request)
        
        return response.withText("This route has middleware")
    }
)

app.get("/users/{id}",
    {
        request, next in let response = try next(request)
        
        return response.withText("And this one too")
    }
)

app.dispatch("GET /users")

print("\n--------------NEXT--REQUEST--------------\n")

app.dispatch("GET /users/1")
