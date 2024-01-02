//
//  ViewController.swift
//  ToDoData1
//
//  Created by Droadmin on 12/12/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func navigateFatchDataView(_ sender: UIButton) {
        let TabBarVc = UIStoryboard(name: "TabBarLikeView", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")as! TabBarViewController
        self.navigationController?.pushViewController(TabBarVc, animated: true)
    }
    
}

