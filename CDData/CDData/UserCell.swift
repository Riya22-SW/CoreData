//
//  UserCell.swift
//  CDData
//
//  Created by admin on 27/11/24.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var emaillable: UILabel!
    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var idlable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
