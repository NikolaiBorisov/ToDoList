//
//  Model.swift
//  ToDoList_UserDefaults
//
//  Created by NIKOLAI BORISOV on 25.03.2021.
//

import Foundation

var toDoList: [[String: Any]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
        UserDefaults.standard.synchronize()
    }
    
    get {
        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
    }
}

func addItem(nameItem: String, isCompleted: Bool = false) {
    toDoList.append(["Name": nameItem, "isCompleted": false])
}

func removeItem(at index: Int) {
    toDoList.remove(at: index)
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = toDoList[fromIndex]
    toDoList.remove(at: fromIndex)
    toDoList.insert(from, at: toIndex)
}

func changeState(at item: Int) -> Bool {
    toDoList[item]["isCompleted"] = !(toDoList[item]["isCompleted"] as! Bool)
    return toDoList[item]["isCompleted"] as! Bool
    
}
