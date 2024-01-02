//
//  TabBarViewController.swift
//  ToDoData1
//
//  Created by Droadmin on 18/12/23.
//

import UIKit

class TabBarViewController: UIViewController,cellDate {
    var selectedDateString:String?
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChiledView()

        // Do any additional setup after loading the view.
    }
    func loadChiledView(){
        let tableAndCollectionViewVc = UIStoryboard(name: "FatchData", bundle: nil).instantiateViewController(withIdentifier: "FatchDataViewController")as! FatchDataViewController
        addChild(tableAndCollectionViewVc)
        tableAndCollectionViewVc.cellDateDelegate = self

        tableAndCollectionViewVc.view.frame = containerView.bounds
        containerView.addSubview(tableAndCollectionViewVc.view)

        tableAndCollectionViewVc.didMove(toParent: self)
    }
    
    @IBAction func addListNavigationBtn(_ sender: UIButton) {
        let addListVC = UIStoryboard(name: "AddListView", bundle: nil).instantiateViewController(withIdentifier: "AddListViewController")as! AddListViewController
        if selectedDateString == nil {
            showAlert(with: "", message: "Please Selecte date")
        }else{
            addListVC.selectedCellDate = self.selectedDateString
            self.navigationController?.pushViewController(addListVC, animated: true)
        }
    }
    func cellDate(cellDate: String) {
        self.selectedDateString = cellDate
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
