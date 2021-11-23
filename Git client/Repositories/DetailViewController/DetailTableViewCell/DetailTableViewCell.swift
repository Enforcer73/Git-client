//
//  ContentCommitTableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 05.11.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class DetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userLabet: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - Accept data from DetailVC
    func configDetailCell(model: CommitData) {
        
        let url = URL(string: model.avatarUrl ?? "")
        userImage.kf.setImage(with: url)
        
        nameLabel.text = model.commitUrl
        userLabet.text = model.login
        messageLabel.text = model.message
        dateLabel.text = model.createdAtFormatted
    }
}

