//: Playground - noun: a place where people can play

import Foundation

app.get("/users",
    {
        request, response, next in
        
        response.headers["Content-Type"] = "text/html"
        
        response.body.appendContentsOf("Hello ")
        
        try next(request, response)
        
        response.body.appendContentsOf(" World!")
    },
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

try app.dispatch(HttpMethod.GET, uri: "/users")