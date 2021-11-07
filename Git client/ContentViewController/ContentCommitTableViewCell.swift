//
//  ContentCommitTableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 05.11.2021.
//

import UIKit

class ContentCommitTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MAKE: - Accept data from ContentVC
    func configContentCommit(model: RepData) {
        userImage.image = model.image
        userLabel.text = model.name
        descriptLabel.text = model.desc
        dateLabel.text = model.date
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
