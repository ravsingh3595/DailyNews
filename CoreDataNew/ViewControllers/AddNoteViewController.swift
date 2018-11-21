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
    
    var isEdit = false
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextView.becomeFirstResponder()
        UITextView.appearance().tintColor = UIColor.black
        
        self.hideKeyboardWhenTappedAround()
        getLocation()
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
        if isEdit {
            // get data from database
        }else{
            if let showMapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowMapViewController") as? ShowMapViewController
            {
                showMapViewController.location = userLocation
                self.present(showMapViewController, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        
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
