//
//  ToDoListItem.swift
//  ToDoList_Realm
//
//  Created by NIKOLAI BORISOV on 25.03.2021.
//

import Foundation
import RealmSwift

class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}
