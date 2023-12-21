//
//  DateViewController.swift
//  ToDoData1
//
//  Created by Droadmin on 13/12/23.
//

import UIKit
protocol DateSelectionDelegate: AnyObject {
    func didSelectDate(selectedDate: Date, senderState: ClanderBtnSenderState)
}
class DateViewController: UIViewController {
    weak var delegate: DateSelectionDelegate?
    var buttonSenderState: ClanderBtnSenderState = .currentDate // Default value

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        let selectedDate = datePicker.date
        delegate?.didSelectDate(selectedDate: selectedDate, senderState: buttonSenderState)
        dismiss(animated: true, completion: nil)
    }
    
   
}
