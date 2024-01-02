//
//  SelectStyleViewController.swift
//  ToDoData1
//
//  Created by Droadmin on 13/12/23.
//

import UIKit
protocol TableViewAndCollectionViewButtonDelegate:AnyObject{
    func tableviewBtn(sender: UIButton)
    func collectionViewBtn(sender: UIButton)
}

class SelectStyleViewController: UIViewController {
    
    weak var tableviewAndCollectionViewBtnDelegate: TableViewAndCollectionViewButtonDelegate?
    @IBOutlet weak var collectionViewBtn: UIButton!
    @IBOutlet weak var tableViewBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        if sender == tableViewBtn {
            tableviewAndCollectionViewBtnDelegate?.tableviewBtn(sender: sender)
            self.dismiss(animated: true)
        }else if sender == collectionViewBtn {
            tableviewAndCollectionViewBtnDelegate?.collectionViewBtn(sender: sender)
            self.dismiss(animated: true)

        }
    }
    
    

}
