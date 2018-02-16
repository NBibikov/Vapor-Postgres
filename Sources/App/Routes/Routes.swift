import Vapor
import PostgreSQLProvider

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }
        
        get("dbversion") { req in
            if let db = self.database?.driver {
                let version = try db.raw("SELECT version()")
                return JSON(node: version)
            }
            return "No db connection"
        }

        get("description") { req in
            return req.description }
        
        get("model") { req in
            let acronym = Acronym(short: "AFK", long: "Away from keyboard")
            return try JSON(node: [
                "short" : acronym.short,
                "long" : acronym.long
                ])
        }
        
        try resource("posts", PostController.self)
    }
}
