//
//  TableViewCellFavorites.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 03.11.2021.
//

import UIKit
import Kingfisher

final class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var favoritButton: UIButton!

    var removeAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction private func removeRepo(_ sender: Any) {
        self.removeAction?()
    }
    
    //MARK: - Accept data from FavoritesVC
    func configDetailFavorit(model: GitDataRealm) {
        userLabel.text = model.repo?.login
        contentLabel.text = model.repo?.nameRep
        descriptLabel.text = model.repo?.descript
        languageLabel.text = model.repo?.language
        forksLabel.text = "\(model.repo?.forksCount ?? 0) forks"
        starsLabel.text = "\(model.repo?.stars ?? 0) stars"

        let url = URL(string: model.repo?.avatarUrl ?? "")
        userImage.kf.setImage(with: url)
    }
}
