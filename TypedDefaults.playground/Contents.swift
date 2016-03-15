//: Playground - noun: a place where people can play

import TypedDefaults

struct Person: UserDefaultsConvertible {
    static var key = "Person"
    
    let name: String
    
    init?(_ object: AnyObject) {
        guard let dict = object as? [String: String], let name = dict["name"] else {
            return nil
        }
        self.name = name
    }
    
    init(name: String) {
        self.name = name
    }
    
    func serialize() -> AnyObject {
        return ["name": name]
    }
}

let person = Person(name: "messi")

let udw = UserDefaultsWrapper(type: Person.self)

udw.setObject(person)
udw.getObject()
udw.removeObject()
