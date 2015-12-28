# swift-webframework

When you run the playground, this code:

```swift
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

try app.dispatch(HttpMethod.GET, uri: "/users")
```

It will print this:

```
HTTP/1.0 200 OK
Content-Type: text/html

Modified by global middleware:
Hello great World!
```
