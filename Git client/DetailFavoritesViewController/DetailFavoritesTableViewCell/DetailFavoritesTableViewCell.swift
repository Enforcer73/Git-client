//
//  FavoritCommitTableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 05.11.2021.
//

import UIKit
import Kingfisher
import RealmSwift


class DetailFavoritesTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userLabet: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    let localRealm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
        
    //MAKE: - Accept data from DetailFavoritVC
    func configDetaiFavoriteTable(model: CommitData) {
        let url = URL(string: model.avatarUrl ?? "")
        userImage.kf.setImage(with: url)
        nameLabel.text = model.name
        userLabet.text = model.login
        messageLabel.text = model.message
        dateLabel.text = model.createdAtFormatted
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
