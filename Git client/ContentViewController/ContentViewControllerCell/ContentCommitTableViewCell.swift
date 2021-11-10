//
//  ContentCommitTableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 05.11.2021.
//

import UIKit
import Kingfisher

class ContentCommitTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    
    private var model: GitData?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    
    //MAKE: - Accept data from ContentVC
    func configContentCommit(model: GitData) {
        userLabel.text = model.login
        descriptLabel.text = model.description
        dateLabel.text = model.updatedAtFormatted
        
        let url = URL(string: model.avatarUrl)
        userImage.kf.setImage(with: url)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

