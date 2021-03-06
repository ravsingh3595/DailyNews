//
//  NoteTableViewCell.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-16.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var onFavButtonTapped: ((_ value: Bool) -> ())?

    @IBOutlet weak var lblNoteTitle: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblNoteContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func locButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        onFavButtonTapped?(sender.isSelected)
    }
    
    func setValues(title: String, noteContent: String, dateTimeString: String) {
        lblNoteTitle.text = title
        lblDateTime.text = dateTimeString
        lblNoteContent.text = noteContent
    }
    
//    @IBAction func switchValueChanged(_ sender: UISwitch) {
//        if (sender.isOn == true){
//            print("UISwitch state is now ON")
//        }
//        else{
//            print("UISwitch state is now Off")
//        }
//    }
}
