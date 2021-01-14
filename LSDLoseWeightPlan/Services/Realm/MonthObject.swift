//
//  MonthObject.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/14.
//

import Foundation
import Realm
import RealmSwift

class MonthObject: Object {
    @objc dynamic var month = ""
    @objc dynamic var imagePath = ""
    
    override class func primaryKey() -> String? {
        return "month"
    }
}
