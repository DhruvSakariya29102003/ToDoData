//
//  FatchDataViewController.swift
//  ToDoData1
//
//  Created by Droadmin on 12/12/23.
//

import UIKit
protocol cellDate:AnyObject {
    func cellDate(cellDate:String)
}

class FatchDataViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var currentMonth: Int = 12
    var datesArray: [CalendarDate] = []
    var readDataArray:[ReadData] = []
    var selectedDateString: String?
    var selectedMenuIndexPath: IndexPath?
    var selectedDateIndexPath: IndexPath?
    let menu:[String] = ["All","To do","In Progress","Xyz","eye","Nail"]
    weak var cellDateDelegate: cellDate?
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var fatchDataCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        DBManager.dbManager.createDatabase()
        DBManager.dbManager.createTable()
        datesArray = generateDatesArray()
        storedDefualtCurrantDate()
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        fatchDataCollectionView.delegate = self
        fatchDataCollectionView.dataSource = self
        fatchDataCollectionView.reloadData()
        menuCollectionView.reloadData()
        dateCollectionView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        fatchDataCollectionView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterData(selectedDateString: selectedDateString)

    }
    
    //MARK: - CollectionView and TableView foramat me data dekhane ke liye
    @IBAction func FatchDataStyaleBtn(_ sender: UIButton) {
        if let popoverContentViewController = UIStoryboard(name: "SelectStyle", bundle: nil).instantiateViewController(withIdentifier: "SelectStyleViewController") as? SelectStyleViewController {
            popoverContentViewController.modalPresentationStyle = .popover
            let popoverController = popoverContentViewController.popoverPresentationController
            popoverController?.sourceView = sender
            popoverController?.sourceRect = sender.bounds
            popoverController?.delegate = self
            popoverController?.permittedArrowDirections = .up
            popoverContentViewController.preferredContentSize = CGSize(width: 250, height: 100)
            popoverContentViewController.tableviewAndCollectionViewBtnDelegate = self
            self.present(popoverContentViewController, animated: true)
        }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func storedDefualtCurrantDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let currentDate = dateFormatter.string(from: Date())
        selectedDateString = currentDate //
        filterData(selectedDateString: selectedDateString)
        cellDateDelegate?.cellDate(cellDate: currentDate)
    }
    func filterData(selectedDateString: String?) {
        guard let selectedDateString = selectedDateString else {
            readDataArray = DBManager.dbManager.readData()
            tableView.reloadData()
            fatchDataCollectionView.reloadData()
            return
        }
        
        readDataArray = DBManager.dbManager.readData().filter { $0.selectedCellDate == selectedDateString }
        tableView.reloadData()
        fatchDataCollectionView.reloadData()
    }
    
    
}

extension FatchDataViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: - selected month ki date generate kar ke store karana
    func generateDatesArray() -> [CalendarDate] {
        
        let currentDate = Date()
        let currentYear = Calendar.current.component(.year, from: currentDate)
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        dateComponents.month = currentMonth
        
        if let startDate = Calendar.current.date(from: dateComponents),
           let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) {
            
            var currentDate = startDate
            while currentDate < endDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd"
                let dayOfMonth = dateFormatter.string(from: currentDate)
                
                dateFormatter.dateFormat = "EEEE"
                let dayOfWeek = dateFormatter.string(from: currentDate)
                
                dateFormatter.dateFormat = "MMMM"
                let month = dateFormatter.string(from: currentDate)
                
                let calendarDate = CalendarDate(date: currentDate, week: dayOfWeek, month: month, dayOfMonth: dayOfMonth)
                datesArray.append(calendarDate)
                
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }
        }
        
        return datesArray
    }
    //MARK: - dateCollectionView and MenuCollectionView me data display karana
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.menuCollectionView{
            return menu.count
        }else if collectionView == self.dateCollectionView{
            if currentMonth > 12 {
                return 0
            } else {
                return datesArray.count
            }
        }else if collectionView == self.fatchDataCollectionView {
            return readDataArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.menuCollectionView {
            let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath)as! MenuCollectionViewCell
            cell.menuLbl.text = menu[indexPath.row]
            
            if indexPath == selectedMenuIndexPath {
                cell.menuLbl.textColor = UIColor.white
                cell.contentView.backgroundColor = UIColor(red: 0.375, green: 0.201, blue: 0.884, alpha: 1)
            } else {
                cell.menuLbl.textColor = UIColor(red: 0.371, green: 0.201, blue: 0.884, alpha: 1)
                cell.contentView.backgroundColor = UIColor(red: 0.928, green: 0.909, blue: 1.0000, alpha: 1)
            }
            
            return cell
        }else if collectionView == self.dateCollectionView{
            let cell = dateCollectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath)as! DateCollectionViewCell
            let calendarDate = datesArray[indexPath.item]
            
            cell.dateLbl.text = calendarDate.dayOfMonth
            cell.weakLbl.text = calendarDate.week
            cell.monthLbl.text = calendarDate.month
            
            if indexPath == selectedDateIndexPath   {
                cellSelectedColor(cell: cell)
            } else {
                cellUnselectedColor(cell: cell)
            }
            
            return cell
            
        }else if collectionView == self.fatchDataCollectionView {
            let cell = fatchDataCollectionView.dequeueReusableCell(withReuseIdentifier: "FatchListCollectionViewCell", for: indexPath)as! FatchListCollectionViewCell
            cell.projectTitleLbl.text = readDataArray[indexPath.row].projectName
            cell.startDateLbl.text = readDataArray[indexPath.row].startDate
            cell.projectStateLbl.text = readDataArray [indexPath.row].projectState
            
            if cell.projectStateLbl.text == "To-do"{
                cell.projectStateLbl.textColor = UIColor(red: 0.225, green: 0.529, blue: 0.999, alpha: 1)
                cell.projectStateLbl.backgroundColor = UIColor(red: 0.890, green: 0.950, blue: 1.000, alpha: 1)
            }else if cell.projectStateLbl.text == "In Progress"{
                cell.projectStateLbl.textColor = UIColor(red: 0.978, green: 0.489, blue: 0.328, alpha: 1)
                cell.projectStateLbl.backgroundColor = UIColor(red: 0.994, green: 0.913, blue: 0.881, alpha: 1)
            }else if cell.projectStateLbl.text == "Done"{
                cell.projectStateLbl.textColor = UIColor(red: 0.371, green: 0.201, blue: 0.884, alpha: 1)
                cell.projectStateLbl.backgroundColor = UIColor(red: 0.931, green: 0.912, blue: 1.000, alpha: 1)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let calendarDate = datesArray[indexPath.row]
        let currentDate = Date()
        
        if collectionView == self.dateCollectionView {
            if Int(calendarDate.dayOfMonth) == Calendar.current.component(.day, from: currentDate) {
                // Check if the cell is not already selected
                if selectedDateIndexPath == nil {
                    // Mark the cell as selected
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    
                    if let dateCell = cell as? DateCollectionViewCell {
                        cellSelectedColor(cell: dateCell)
                    }
                }
            }
        }
    }
    
    //MARK: - selected cell date ke according data display karna
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == self.dateCollectionView {
            let selectedDate = datesArray[indexPath.item].date
            let currentDate = Calendar.current.startOfDay(for: Date())
            if selectedDate < currentDate{
                return false
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM, yyyy"
                self.selectedDateString = dateFormatter.string(from: selectedDate)
                cellDateDelegate?.cellDate(cellDate: selectedDateString ?? "")
                
                return true
            }
        }else if collectionView == self.menuCollectionView {
            return true
        }else if collectionView == self.fatchDataCollectionView{
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.menuCollectionView {
            selectedMenuIndexPath = indexPath
            menuCollectionView.reloadData()
            
        }else if collectionView == self.dateCollectionView {
            
            selectedDateIndexPath = indexPath
            dateCollectionView.reloadData()
            filterData(selectedDateString: selectedDateString)
            
            // Update the appearance of the selected cell
            if let selectedCell = dateCollectionView.cellForItem(at: indexPath) as? DateCollectionViewCell {
                cellSelectedColor(cell: selectedCell)
            }
        }else if collectionView == self.fatchDataCollectionView {
            let cellselectData = readDataArray[indexPath.row]
            let updateVc = UIStoryboard(name: "AddListView", bundle: nil).instantiateViewController(withIdentifier: "AddListViewController")as! AddListViewController
            updateVc.cellSelectData = cellselectData
            navigationController?.pushViewController(updateVc, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.menuCollectionView {
            selectedMenuIndexPath = nil
            menuCollectionView.reloadData()
        }
        else if collectionView == self.dateCollectionView {
            selectedDateIndexPath = nil
            if let deselectedCell = dateCollectionView.cellForItem(at: indexPath) as? DateCollectionViewCell {
                
                cellUnselectedColor(cell: deselectedCell)
            }
            dateCollectionView.reloadData()
        }
    }
    func cellUnselectedColor(cell:DateCollectionViewCell){
        cell.dateLbl.textColor = UIColor.black
        cell.weakLbl.textColor = UIColor.black
        cell.monthLbl.textColor = UIColor.black
        cell.contentView.backgroundColor = UIColor.white
    }
    func cellSelectedColor(cell:DateCollectionViewCell){
        cell.dateLbl.textColor = UIColor.white
        cell.weakLbl.textColor = UIColor.white
        cell.monthLbl.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor(red: 0.375, green: 0.201, blue: 0.884, alpha: 1)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.fatchDataCollectionView {
            let collectionViewWidth = fatchDataCollectionView.frame.size.width
            let cellWidth = (collectionViewWidth - 30) / 2
            
            return CGSize(width: cellWidth, height: 165)
        }else if collectionView == self.menuCollectionView {
            let text = menu[indexPath.row]
            let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize: 20)]).width + 45
            
            return CGSize(width: cellWidth, height: 50)
        }else if collectionView == dateCollectionView {
            return CGSize(width: 128, height: 120)
        }
        return CGSize(width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.fatchDataCollectionView {
            return 10
        }
        else if collectionView == self.menuCollectionView {
            return 20
        }
        else if collectionView == dateCollectionView {
            return 10
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == menuCollectionView {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}
extension FatchDataViewController: TableViewAndCollectionViewButtonDelegate {
    //MARK: - tableview button ki clike pe tableview format me data display karana
    func tableviewBtn(sender: UIButton) {
        tableView.isHidden = false
        fatchDataCollectionView.isHidden = true
    }
    //MARK: - collectionview button ki clike pe collectionview format me data display karna
    
    func collectionViewBtn(sender: UIButton) {
        tableView.isHidden = true
        fatchDataCollectionView.isHidden = false
    }
    
    
}
extension FatchDataViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FatchListTableViewCell")as! FatchListTableViewCell
        cell.projectNameLbl.text = readDataArray[indexPath.row].projectName
        cell.dateLbl.text = readDataArray[indexPath.row].startDate
        cell.projectStateLbl.text = readDataArray[indexPath.row].projectState
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellselectData = readDataArray[indexPath.row]
        let updateVc = UIStoryboard(name: "AddListView", bundle: nil).instantiateViewController(withIdentifier: "AddListViewController")as! AddListViewController
        updateVc.cellSelectData = cellselectData
        navigationController?.pushViewController(updateVc, animated: true)
    }
    
    
}



