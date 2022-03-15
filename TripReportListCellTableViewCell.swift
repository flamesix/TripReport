//
//  TripReportListCellTableViewCell.swift
//  TripReport
//
//  Created by Юрий Гриневич on 26.02.2022.
//

import UIKit

class TripReportListCellTableViewCell: UITableViewCell {
     
    @IBOutlet weak var numberTripReportLabel: UILabel!
    @IBOutlet weak var nameOfCityLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with tripReport: TripReport) {
        numberTripReportLabel.text = String(tripReport.numberOfTripReport)
        nameOfCityLabel.text = tripReport.cityName
        contactLabel.text = tripReport.contractNumber
        phoneLabel.text = tripReport.lrcName
    }

}
