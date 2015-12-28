//: Playground - noun: a place where people can play

import Foundation

var globalMiddleware: Middleware = {
    req, res, nxt in
    
    res.body = "Modified by global middleware:\n" + res.body
    
    try nxt(req, res)
}

var routeMiddleware: Middleware = {
    request, response, next in
    
    response.headers["Content-Type"] = "text/html"
    
    response.body.appendContentsOf("Hello ")
    
    try next(request, response)
    
    response.body.appendContentsOf(" World!")
}

app.add(globalMiddleware)

app.get("/users",
    routeMiddleware,
    {
        request, response, next in
        
        // This line has no effect,
        // cause this is the last handler,
        // but I just want to show that
        // having it doesn't hurt either
        try next(request, response)
        
        response.body.appendContentsOf("great")
    }
)

app.get("/users/{id:[0-9]+}",
    {
        request, response, next in
        
        response.body.appendContentsOf("This is without route middleware")
    }
)

try app.dispatch(HttpMethod.GET, uri: "/users/4")
