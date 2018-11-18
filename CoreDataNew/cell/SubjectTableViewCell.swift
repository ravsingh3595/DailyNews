//
//  SubjectTableViewCell.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-16.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myImageView.roundImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(title: String) {
        myImageView.image = LetterImageGenerator.imageWith(name: title)
        titleLabel.text = title;
    }
    
}
