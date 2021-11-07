//
//  DetailCommitTableViewCell.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 07.11.2021.
//

import UIKit

class DetailCommitTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelCommit: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MAKE: - Accept data from DetalCommitVC
    func configLabelCommit(model: Commit) {
        labelCommit.text = model.codCom
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
