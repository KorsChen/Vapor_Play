import Foundation
import Leaf
import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get { req -> Future<View> in
        let context = [String: String]()
        return try req.view().render("home", context)
    }
    
    router.get("contact") { req -> Future<View> in
        let context = [String: String]()
        return try req.view().render("contact", context)
    }
    
    router.get("staff", String.parameter) { req -> Future<View> in
        let name = try req.parameters.next(String.self)
        
        // create some dummy data to work with
        let bios = [
            "kirk": "My name is James Kirk and I love snakes.",
            "picard": "My name is Jean-Luc Picard and I'm mad for fish.",
            "sisko": "My name is Benjamin Sisko and I'm all about the budgies.",
            "janeway": "My name is Kathryn Janeway and I want to hug every hamster.",
            "archer": "My name is Jonathan Archer and beagles are my thing."
        ]
        
        // define the struct we'll pass to the template
        struct StaffView: Codable {
            var name: String?
            var bio: String?
            var allNames: [String]
        }
        
        let context: StaffView
        
        // attempt to find a staff member by this name and fill in our struct
        if let bio = bios[name] {
            context = StaffView(name: name, bio: bio, allNames: bios.keys.sorted())
        } else {
            context = StaffView(name: nil, bio: nil, allNames: bios.keys.sorted())
        }
        
        // render the template with whatever we have
        return try req.view().render("staff", context)
    }
}
