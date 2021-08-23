//
//  ArticleCell.swift
//  Articles
//
//  Created by Safaa Khalaf on 22/8/21.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var thumbnailImg: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
