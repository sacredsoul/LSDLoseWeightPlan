//
//  RealmManager.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/14.
//

import Foundation
import Realm
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("month.realm")
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Writes
    func update(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    // MARK: - Queries
    func query<T: Object>(type: T.Type) -> Results<T>? {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
}
