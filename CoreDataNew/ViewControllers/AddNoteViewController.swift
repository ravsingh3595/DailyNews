//
//  AddNoteViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-17.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    var isEdit = false
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var subjectId = 0
    var subject :Subject?
    var note: Note?
    var isSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextView.becomeFirstResponder()
        UITextView.appearance().tintColor = UIColor.black
        
        self.hideKeyboardWhenTappedAround()
        getLocation()
        
        UITextView.appearance().tintColor = UIColor.black
        
        noteTextView.placeholder = "Enter Note.."
        titleTextView.placeholder = "Enter Note Title.."
        
        if(isEdit){
            titleTextView.text = note?.title
            noteTextView.text = note?.content
           
            // value from database
//            if (note?.isImp)!{
//                favoriteButton.image = UIImage(named: "favorite.png")
//            }else{
//                favoriteButton.image = UIImage(named: "unfavorite.png")
//            }
            
        }
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
    
    @IBAction func locationButtonClicked(_ sender: UIBarButtonItem) {
        if let showMapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowMapViewController") as? ShowMapViewController
        {
            if isEdit {
                // get data from database
                var location = CLLocationCoordinate2D()
                location.latitude = note?.latitude ?? -1
                location.longitude = note?.longitude ?? -1
            }else{
                showMapViewController.location = userLocation
            }
            
            self.present(showMapViewController, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        if(isEdit){
            // value from database
//            note?.isImp = !((note?.isImp)!)
//            if (note?.isImp)!{
//                sender.image = UIImage(named: "favorite.png")
//            }else{
//                sender.image = UIImage(named: "unfavorite.png")
//            }
        }else{
            isSelected = !isSelected
            if (isSelected){
                sender.image = UIImage(named: "favorite.png")
            }else{
                sender.image = UIImage(named: "unfavorite.png")
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let note = Note(context: context)
        note.title = titleTextView.text
        note.content = noteTextView.text
        note.latitude = userLocation.latitude
        note.longitude = userLocation.longitude
        note.subjectId = subject?.subjectId ?? 0
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
    }
    
    func getLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func openMapForPlace() {
        
        let latitude: CLLocationDegrees = userLocation.latitude
        let longitude: CLLocationDegrees = userLocation.longitude

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)

    }

}

extension AddNoteViewController: UITextViewDelegate, CLLocationManagerDelegate{
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLocation = locValue
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    
}
