//
//  CarCell.swift
//  MVVMPrac
//
//  Created by USER on 2021/02/02.
//

import UIKit

class CarCell: UITableViewCell {
    static let identifier = "CarCell"

    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(from carDTO: CarDTO) {
        makeLabel.text = carDTO.make
        modelLabel.text = carDTO.model
    }
}
