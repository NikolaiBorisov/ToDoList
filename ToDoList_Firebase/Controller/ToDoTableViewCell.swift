//
//  ToDoTableViewCell.swift
//  ToDoList_Firebase
//
//  Created by NIKOLAI BORISOV on 25.03.2021.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var todoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}