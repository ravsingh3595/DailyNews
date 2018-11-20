//
//  AddNoteViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-17.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        titleTextView.delegate = self
        // Do any additional setup after loading the view.
        titleTextView.becomeFirstResponder()
        UITextView.appearance().tintColor = UIColor.black
        
        self.hideKeyboardWhenTappedAround()
        
//        titleTextView.placeholder = "Enter title here.."
//        noteTextView.placeholder = "Enter text here.."
        
        
    }
    

    @IBAction func addImageButtonClicked(_ sender: UIButton) {
        
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            
            let compressedIMg = image.resized(withPercentage: 0.8)
            var attributedString :NSMutableAttributedString!
            attributedString = NSMutableAttributedString(attributedString:self.noteTextView.attributedText)
            let textAttachment = NSTextAttachment()
            textAttachment.image = compressedIMg
            
            let oldWidth = textAttachment.image!.size.width;
            
            //I'm subtracting 10px to make the image display nicely, accounting
            //for the padding inside the textView
            
            let scaleFactor = oldWidth / (self.noteTextView.frame.size.width - 10);
            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.append(attrStringWithImage)
            attributedString.append(NSAttributedString(string: "\n"))
            self.noteTextView.attributedText = attributedString;
            
            
            self.noteTextView.becomeFirstResponder()
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddNoteViewController: UITextViewDelegate{
//    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = noteTextView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame
//    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("====== textViewShouldBeginEditing =====")
        if(textView == titleTextView){
            addButton.isUserInteractionEnabled = false
            addButton.isEnabled = false
        }else{
            addButton.isUserInteractionEnabled = true
            addButton.isEnabled = true
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("====== textViewDidBeginEditing =====")
        if(textView == titleTextView){
            addButton.isUserInteractionEnabled = false
            addButton.isEnabled = false
        }else{
            addButton.isUserInteractionEnabled = true
            addButton.isEnabled = true
        }
    }
}
