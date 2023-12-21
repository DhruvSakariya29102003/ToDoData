//
//  FatchListTableViewCell.swift
//  ToDoData1
//
//  Created by Droadmin on 13/12/23.
//

import UIKit

class FatchListTableViewCell: UITableViewCell {

    @IBOutlet weak var projectStateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        projecStateColor()
        // Configure the view for the selected state
    }
    func projecStateColor(){
        if projectStateLbl.text == "To-do"{
            projectStateLbl.textColor = UIColor(red: 0.225, green: 0.529, blue: 0.999, alpha: 1)
            projectStateLbl.backgroundColor = UIColor(red: 0.890, green: 0.950, blue: 1.000, alpha: 1)
        }else if projectStateLbl.text == "In Progress"{
            projectStateLbl.textColor = UIColor(red: 0.978, green: 0.489, blue: 0.328, alpha: 1)
            projectStateLbl.backgroundColor = UIColor(red: 0.994, green: 0.913, blue: 0.881, alpha: 1)
        }else if projectStateLbl.text == "Done"{
            projectStateLbl.textColor = UIColor(red: 0.371, green: 0.201, blue: 0.884, alpha: 1)
            projectStateLbl.backgroundColor = UIColor(red: 0.931, green: 0.912, blue: 1.000, alpha: 1)
        }
    }
}

