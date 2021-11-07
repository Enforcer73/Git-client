//
//  TableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MAKE: - Accept data from VC
    func configFirst(model: Reposit) {
        userLabel.text = model.name
        contentLabel.text = model.content
        descriptLabel.text = "Description: \(model.descript)"
        languageLabel.text = model.lang
        forksLabel.text = "\(model.fork) forks"
        starsLabel.text = "\(model.star) stars"
        userImage.image = model.image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
