//
//  AddListViewController.swift
//  ToDoData1
//
//  Created by Droadmin on 13/12/23.
//

import UIKit
enum ClanderBtnSenderState {
    case currentDate
    case startDate
    case endDate
}

class AddListViewController: UIViewController, UIPopoverPresentationControllerDelegate,DateSelectionDelegate {
    var selectedCellDate:String?
    var cellSelectData:ReadData?
    let projectState:[String] = ["Done","In Progress","To-do"]
    @IBOutlet weak var endDateLbl        : UILabel!
    @IBOutlet weak var dropDownBtn       : UIButton!
    @IBOutlet weak var endDateBtn        : UIButton!
    @IBOutlet weak var currentDateBtn    : UIButton!
    @IBOutlet weak var startDatebtn      : UIButton!
    @IBOutlet weak var startDateLbl      : UILabel!
    @IBOutlet weak var currentDateLbl    : UILabel!
    @IBOutlet weak var projectNameTxt    : UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var dropDownTableView : UITableView!
    @IBOutlet weak var tableViewHight    : NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDateBtn.isEnabled = false
        tableViewHight.constant = 0
        dropDownTableView.isHidden = true
        updateData()
        
        // Do any additional setup after loading the view.
    }
    func updateData(){
        if cellSelectData != nil {
            currentDateLbl.text     = cellSelectData?.selectedCellDate
            projectNameTxt.text     = cellSelectData?.projectName
            descriptionTxtView.text = cellSelectData?.description
            startDateLbl.text       = cellSelectData?.startDate
            endDateLbl.text         = cellSelectData?.endDate
            dropDownBtn.setTitle(cellSelectData?.projectState, for: .normal)
        }else{
            dropDownBtn.setTitle("Selected Project State", for: .normal)
        }
    }
    // MARK: - Data Database me insert karna and blank data pe alert dikhana
    @IBAction func addProjectBtn(_ sender: UIButton) {
        let alertMsg = self.projectNameTxt.text?.count == 0 ? "Please Enter Name" : self.descriptionTxtView.text?.count == 0 ? "Please enter description" : self.startDateLbl.text?.count == 0 ? "Please Selecte Start Date" : self.endDateLbl.text?.count == 0 ? "Please Selecte End Date" : self.dropDownBtn.titleLabel?.text == "Selected Project State" ? "Please Selecte Project State" : ""
        if alertMsg.count > 0 {
            self.showAlert(with: "", message: alertMsg)
        }else if cellSelectData != nil{
            DBManager.dbManager.updateData(description: descriptionTxtView.text ?? "", startDate: startDateLbl.text ?? "", enDate: endDateLbl.text ?? "", projectState: dropDownBtn.titleLabel?.text ?? "", id: cellSelectData!.id)
            self.showAlert(with: "Success", message: "Record update sucess fully") {
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            DBManager.dbManager.insert(projectName: projectNameTxt.text ?? "" , description: descriptionTxtView.text ?? "" , selectedCellDate: selectedCellDate ?? "", startDate: startDateLbl.text ?? "", endDate: endDateLbl.text ?? "", ProjectState: dropDownBtn.titleLabel?.text ?? "")
            self.showAlert(with: "Success", message: "Record inserted sucess fully") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func dropDownBtn(_ sender: UIButton) {
        if dropDownTableView.isHidden {
            dropDownAnimation(toogle: true)
        }else{
            dropDownAnimation(toogle: false)
        }
    }
    func dropDownAnimation(toogle: Bool){
        if toogle {
            UIView.animate(withDuration: 0.0) {
                self.tableViewHight.constant = 170
                self.dropDownTableView.isHidden = false
            }
        }else {
            UIView.animate(withDuration: 0.0) {
                self.tableViewHight.constant = 0
                self.dropDownTableView.isHidden = true
            }
        }
    }
    // MARK: - pehale vale view me navigation hona
    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - calanedar button ki clike pe calander display karna
    @IBAction func dateBtn(_ sender: UIButton) {
        var buttonSenderState: ClanderBtnSenderState = .currentDate
        if sender == startDatebtn {
            buttonSenderState = .startDate
        }else if sender == endDateBtn {
            buttonSenderState = .endDate
        }
        if let dateVc = UIStoryboard(name: "DateView", bundle: nil).instantiateViewController(withIdentifier: "DateViewController")as? DateViewController {
            dateVc.modalPresentationStyle = .popover
            let dateController = dateVc.popoverPresentationController
            dateController?.sourceView = sender
            dateController?.sourceRect = sender.bounds
            dateController?.delegate = self
            dateController?.permittedArrowDirections = .down
            dateVc.preferredContentSize = CGSize(width: 320, height: 350)
            dateVc.delegate = self
            dateVc.buttonSenderState = buttonSenderState
            self.present(dateVc, animated: true)
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    // MARK: - Alert dikhane ka function
    func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Selected date label pe display karna 
    func didSelectDate(selectedDate: Date, senderState: ClanderBtnSenderState) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        switch senderState {
        case .currentDate:
            currentDateLbl.text = formattedDate
        case .startDate:
            if let endDate = dateFormatter.date(from: endDateLbl.text ?? ""), selectedDate > endDate {
                DispatchQueue.main.async {
                    self.showAlert(with: "", message: "Start Date is greater than End Date!!")
                }
                return
            }
            startDateLbl.text = formattedDate
        case .endDate:
            if let startDate = dateFormatter.date(from: startDateLbl.text ?? ""), selectedDate < startDate {
                DispatchQueue.main.async {
                    self.showAlert(with: "", message: "End Date is less than Start Date!!")
                }
                return
            }
            endDateLbl.text = formattedDate
        }
    }
}
extension AddListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectState.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dropDownTableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell") as! DropDownTableViewCell
        cell.dropDownLbl.text = projectState[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownBtn.setTitle("\(projectState[indexPath.row])", for: .normal)
        dropDownAnimation(toogle: false)
    }
}

