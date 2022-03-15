//
//  TripReportTableViewController.swift
//  TripReport
//
//  Created by Юрий Гриневич on 14.02.2022.
//

import UIKit

class TripReportTableViewController: UITableViewController {
    
    // MARK: - Properties for calculations
    
    let moneyPerDay = 2025
    let autoCompensation = 16
    var numberOfDays = 0
    var dailyMoney = 0
    var autoMoney = 0
    var totalMoney = 0.0
    
    
    var tripReport: TripReport?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tripReportNumberTextField: UITextField!
    @IBOutlet weak var lrcNumberTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UITextField!
    @IBOutlet weak var nameOfLrcTextField: UITextField!
    @IBOutlet weak var contractNumberTextField: UITextField!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var oneDaySwitcher: UISwitch!
    @IBOutlet weak var startEndDateLabel: UILabel!
    @IBOutlet weak var dailyMoneyLabel: UILabel!
    @IBOutlet weak var autoMoneyLabel: UILabel!
    
    @IBOutlet weak var autoSwitcher: UISwitch!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    
    // MARK: - Properties for tableView delegate methods
    
    let startDatePickerIndexPath = IndexPath(row: 2, section: 1)
    let endDatePickerIndexPath = IndexPath(row: 4, section: 1)
    let startDateLabelIndexPath = IndexPath(row: 1, section: 1)
    let endDateLabelIndexPath = IndexPath(row: 3, section: 1)
    let distanceLabelIndexPath = IndexPath(row: 1, section: 2)
    let autoMoneyLabelIndexPath = IndexPath(row: 1, section: 3)
    
    var isStartDatePickerVisible: Bool = false {
        didSet {
            startDatePicker.isHidden = !isStartDatePickerVisible
        }
    }
    
    var isEndDatePickerVisible: Bool = false {
        didSet {
            endDatePicker.isHidden = !isEndDatePickerVisible
        }
    }
    
    init?(coder: NSCoder, tripReport: TripReport?){
        self.tripReport = tripReport
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.hideKeyboardWhenTappedAround()
        self.setupHideKeyboardOnTap()
        
        updateView()
        updateDate()
        oneDaySwitchToggle()
        updateExpenses()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Functions
    
    func updateView() {
        if let tripReport = tripReport {
            let stringTripReport = String(tripReport.numberOfTripReport)
            tripReportNumberTextField.text = stringTripReport
            lrcNumberTextField.text = tripReport.lrcNumber
            nameOfLrcTextField.text = tripReport.lrcName
            contractNumberTextField.text = tripReport.contractNumber
            cityNameLabel.text = tripReport.cityName
        }
    }
    
    func oneDaySwitchToggle() {
        if oneDaySwitcher.isOn {
            
            startEndDateLabel.text = "Start/End Date"
        } else {
            
            startEndDateLabel.text = "Start Date"
            
        }
        updateExpenses()
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func autoSwitchToggle() {
        if !autoSwitcher.isOn {
            autoMoney = 0
            
            //autoMoneyLabel.text = "RUB: 0"
        }
    }
    
    func updateDate() {
        startDateLabel.text = startDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        endDateLabel.text = endDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateExpenses() {
        dailyMoney = numberOfDays * moneyPerDay
        if oneDaySwitcher.isOn {
            numberOfDays = 1
            dailyMoneyLabel.text = dailyMoney.formatted(.currency(code: "rub"))
        } else if !oneDaySwitcher.isOn {
            let startOfDay = Calendar.current.startOfDay(for: startDatePicker.date)
            startDatePicker.date = startOfDay
            let dateComponents = Calendar.current.dateComponents([.day], from: startOfDay, to: endDatePicker.date)
            numberOfDays = (dateComponents.day! + 1)
            
            dailyMoneyLabel.text = dailyMoney.formatted(.currency(code: "rub"))
        }
        
        
        if autoSwitcher.isOn {
            if let distanceByAutoString = distanceTextField.text {
                let distanceByAutoInt = Int(distanceByAutoString) ?? 0
                autoMoney = Int(Double(distanceByAutoInt * autoCompensation) / 0.865)
                autoMoneyLabel.text = autoMoney.formatted(.currency(code: "rub"))
            } /*else if !autoSwitcher.isOn {
               autoMoney = 0
               print(autoMoney)
               // autoMoneyLabel.text = "RUB: \(autoMoney)"
               }*/
        }
        totalMoney = Double(numberOfDays * moneyPerDay) + Double(autoMoney)
        // totalMoneyLabel.text = "RUB: \(totalMoney)"
        totalMoneyLabel.text = totalMoney.formatted(.currency(code: "rub"))
    }
    
    // MARK: - IBActions
    
    @IBAction func oneDaySwitch(_ sender: UISwitch) {
        oneDaySwitchToggle()
        updateExpenses()
    }
    
    @IBAction func startEndDatePicker(_ sender: UIDatePicker) {
        updateDate()
        updateExpenses()
    }
    
    @IBAction func autoSwitch(_ sender: UISwitch) {
        autoSwitchToggle()
        updateExpenses()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let stringNumberOfTripReport = tripReportNumberTextField.text,
              let numberOfTripReport = Int(stringNumberOfTripReport),
              let lrcNumber = lrcNumberTextField.text,
              let lrcName = nameOfLrcTextField.text,
              let contractNumber = contractNumberTextField.text,
              let cityName = cityNameLabel.text else { return }
        
           tripReport = TripReport(numberOfTripReport: numberOfTripReport, cityName: cityName, lrcNumber: lrcNumber, lrcName: lrcName, contractNumber: contractNumber)
        
        performSegue(withIdentifier: "unwindToTripReport", sender: self)
        
    }
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateExpenses()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if oneDaySwitcher.isOn {
            switch indexPath {
            case endDateLabelIndexPath:
                return 0
            case startDatePickerIndexPath where isStartDatePickerVisible == false:
                return 0
            case endDatePickerIndexPath:
                return 0
            case distanceLabelIndexPath where autoSwitcher.isOn == false:
                return 0
            case distanceLabelIndexPath where autoSwitcher.isOn == true:
                return UITableView.automaticDimension
            case autoMoneyLabelIndexPath where autoSwitcher.isOn == false:
                return 0
            case autoMoneyLabelIndexPath where autoSwitcher.isOn == true:
                return UITableView.automaticDimension
            default:
                return UITableView.automaticDimension
            }
        } else {
            switch indexPath {
            case startDatePickerIndexPath where isStartDatePickerVisible == false:
                return 0
            case endDatePickerIndexPath where isEndDatePickerVisible == false:
                return 0
            case distanceLabelIndexPath where autoSwitcher.isOn == false:
                return 0
            case distanceLabelIndexPath where autoSwitcher.isOn == true:
                return UITableView.automaticDimension
            case autoMoneyLabelIndexPath where autoSwitcher.isOn == false:
                return 0
            case autoMoneyLabelIndexPath where autoSwitcher.isOn == true:
                return UITableView.automaticDimension
            default:
                return UITableView.automaticDimension
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case startDatePickerIndexPath:
            return 190
        case endDatePickerIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        updateExpenses()
        
        
        if indexPath == startDateLabelIndexPath {
            isStartDatePickerVisible.toggle()
        } else if indexPath == endDateLabelIndexPath {
            isEndDatePickerVisible.toggle()
        } else if indexPath == startDateLabelIndexPath && oneDaySwitcher.isOn == true {
            isStartDatePickerVisible.toggle()
            
        } else {return}
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 4
     }
     */
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard segue.identifier == "unwindToTripReport" else {return}
         
         let intNumberOfTripReport = Int(tripReportNumberTextField.text!)
         let numberOfTripReport = intNumberOfTripReport ?? 0
         let cityName = cityNameLabel.text ?? ""
         let lrcNumber = lrcNumberTextField.text ?? ""
         let lrcName = nameOfLrcTextField.text ?? ""
         let contractNumber = contractNumberTextField.text ?? ""
         
         tripReport = TripReport(numberOfTripReport: numberOfTripReport, cityName: cityName, lrcNumber: lrcNumber, lrcName: lrcName, contractNumber: contractNumber)
         
         
     }
     
    
}

// MARK: - Extensions

/*
 Method working with // self.hideKeyboardWhenTappedAround() in viewDidLoad but not working with stepper
 
 extension UITableViewController {
 func hideKeyboardWhenTappedAround() {
 let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
 view.addGestureRecognizer(tap)
 
 }
 
 @objc func dismissKeyboard() {
 view.endEditing(true)
 }
 }
 */
/*
 Method working with self.setupHideKeyboardOnTap() in viewDidLoad
 
 
 */
extension UITableViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
