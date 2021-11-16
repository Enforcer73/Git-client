//
//  TableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit
import Kingfisher
import RealmSwift

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
    func configCell(model: GitData) {
        userLabel.text = model.login
        contentLabel.text = model.nameRep
        descriptLabel.text = model.descript
        languageLabel.text = model.language
        forksLabel.text = "\(model.forksCount ?? 0) forks"
        starsLabel.text = "\(model.stars ?? 0) stars"
        let url = URL(string: model.avatarUrl ?? "")
        userImage.kf.setImage(with: url)
    }
        

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
