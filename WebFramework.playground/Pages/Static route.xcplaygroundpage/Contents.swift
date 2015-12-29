//: This demonstrates a simple static route with one handler

app.get("/users")
{
    _, response, _ in
    
    response.headers["Content-type"] = "text/html"
    response.body = "Hello You!"
}

try app.dispatch(HttpMethod.GET, uri: "/users")

//: [Next](@next)
