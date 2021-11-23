//
//  TableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 02.11.2021.
//

import UIKit
import Kingfisher


final class TableViewCell: UITableViewCell {

    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var descriptLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var favoritButton: UIButton!
 
    let starFill = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal)
    let star = UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal)
    var buttonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - Save repo from Repo start VC
    @IBAction func saveButton(_ sender: Any) {
        self.buttonAction?()
    }

    //MARK: - Accept data from VC
    func configCell(model: GitDataRealm) {
        
        favoritButton.setImage(model.isFavourite ? starFill : star, for: .normal)
        
        userLabel.text = model.repo?.login
        contentLabel.text = model.repo?.nameRep
        descriptLabel.text = model.repo?.descript
        languageLabel.text = model.repo?.language
        forksLabel.text = "\(model.repo?.forksCount ?? 0) forks"
        starsLabel.text = "\(model.repo?.stars ?? 0) stars"
        
        let url = URL(string: model.repo?.avatarUrl ?? "")
        userImage.kf.setImage(with: url)
    }

    override func prepareForReuse() {
        favoritButton.setImage(nil, for: .normal)
    }
}
