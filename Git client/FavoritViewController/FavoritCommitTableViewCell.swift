//
//  FavoritCommitTableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 05.11.2021.
//

import UIKit

class FavoritCommitTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MAKE: - Accept data from FavoritVC
    func configFavoritCommit(model: RepData) {
        userImage.image = model.image
        userLabel.text = model.name
        dateLabel.text = model.date
        descriptLabel.text = model.desc
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
