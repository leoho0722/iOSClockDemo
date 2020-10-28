import Foundation
import RealmSwift

class ClockRealm: Object {
    @objc dynamic var clockID = UUID().uuidString
    @objc dynamic var time:String = ""
    @objc dynamic var repeatDay:String = ""
    @objc dynamic var clockDecscription = ""
    @objc dynamic var sound:String = ""
    @objc dynamic var afterRemind:Bool = true
    
    override static func primaryKey() -> String {
        return "clockID"
    }
}
