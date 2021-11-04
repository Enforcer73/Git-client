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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MAKE: - Labels binding
    func configFavorit(nick: String, content: String, descript: String, lang: String, fork: String, star: String) {
        userLabel.text = nick
        contentLabel.text = content
        descriptLabel.text = "Description: \(descript)"
        languageLabel.text = lang
        forksLabel.text = "\(fork) forks"
        starsLabel.text = "\(star) stars"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
