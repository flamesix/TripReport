//
//  TripReportListTableViewController.swift
//  TripReport
//
//  Created by Юрий Гриневич on 26.02.2022.
//

import UIKit

class TripReportListTableViewController: UITableViewController {
    
    struct PropertyKeys {
        static let tripReportListCell = "TripReportListCell"
    }
    
    
    
    var tripReports: [TripReport] = [] {
        didSet {
            TripReport.saveToFile(tripReports: tripReports)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if let savedTripReports = TripReport.loadFromFile() {
            tripReports = savedTripReports
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
  
    
   
    
    
    @IBSegueAction func addTripReport(_ coder: NSCoder) -> TripReportTableViewController? {
        return TripReportTableViewController(coder: coder, tripReport: nil)
    }
    
    
    @IBSegueAction func editTripReport(_ coder: NSCoder, sender: Any?) -> TripReportTableViewController? {
        let tripReportToEdit: TripReport?
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            tripReportToEdit = tripReports[indexPath.row]
        } else {
            tripReportToEdit = nil
        }
        
        return TripReportTableViewController(coder: coder, tripReport: tripReportToEdit)
    }
    
   
   
    
    @IBAction func unwindToTripReportListTablewViewController(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "unwindToTripReport",
        let tripReportTableViewController = unwindSegue.source as? TripReportTableViewController,
        let tripReport = tripReportTableViewController.tripReport
        else {
            return
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tripReports[selectedIndexPath.row] = tripReport
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: tripReports.count, section: 0)
            tripReports.append(tripReport)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tripReports.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.tripReportListCell, for: indexPath) as! TripReportListCellTableViewCell
        
        let tripReport = tripReports[indexPath.row]
        cell.update(with: tripReport)
    
        
        return cell
    }
    
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
         tripReports.remove(at: indexPath.row)
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
