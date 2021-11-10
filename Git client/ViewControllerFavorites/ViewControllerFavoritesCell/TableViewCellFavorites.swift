//
//  TableViewCellFavorites.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit

class TableViewCellFavorites: UITableViewCell {


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

    //MAKE: - Accept data from VCFavorites
    func configFavorit(model: GitData) {
        userLabel.text = model.login
        contentLabel.text = model.name
        descriptLabel.text = model.description
        languageLabel.text = model.language
        forksLabel.text = "\(model.forksCount) forks"
        starsLabel.text = "\(model.stars) stars"
//        userImage.image = model.image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
