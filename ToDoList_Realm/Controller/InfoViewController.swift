//
//  InfoViewController.swift
//  ToDoList_Realm
//
//  Created by NIKOLAI BORISOV on 25.03.2021.
//

import UIKit
import RealmSwift

class InfoViewController: UIViewController {
    
    public var item: ToDoListItem?
    public var deletionHandler: (() -> Void)?
    
    private let realm = try! Realm()
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapdelete))

    }
    
    @objc private func didTapdelete() {
        guard
            let myItem = self.item else {
            return
        }
        
        realm.beginWrite()
        
        realm.delete(myItem)
        
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
        
    }

}
