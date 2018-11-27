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
import CoreData

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    var isEdit = false
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var subjectId = 0
    var subject :Subject?
    var note: Note?
    var isSelected = false
    var selectedIndex: Int?
    var noteArray: [Note]?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        getData()
        titleTextView.becomeFirstResponder()
        UITextView.appearance().tintColor = UIColor.black
        
        self.hideKeyboardWhenTappedAround()
        getLocation()
        
        UITextView.appearance().tintColor = UIColor.black
        
        
//        print(subject?.subjectTitle)
        
        if(isEdit){
            getDataForSubject(subject: (subject?.subjectTitle)!)
            titleTextView.text = noteArray?[selectedIndex!].title ?? ""
            noteTextView.text = noteArray?[selectedIndex!].content ?? ""
            if (noteArray?[selectedIndex!].isImp ?? false){
//                favoriteButton.image = UIImage(named: "favorite.png")
            }else{
//                favoriteButton.image = UIImage(named: "unfavorite.png")
            }
            
            if let image = noteArray?[selectedIndex!].contentImage{
                imageView1.image = UIImage(data: image)
            }
//            imageView1.image = noteArray?[selectedIndex!].contentImage
        
        }else{
            print(subject?.subjectTitle ?? "")
            noteTextView.placeholder = "Enter Note.."
            titleTextView.placeholder = "Enter Note Title.."
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(tapGestureRecognizer)
    }
    
//    func getData() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        do{
//            self.noteArray = try context.fetch(Note.fetchRequest())
//        }
//        catch
//        {
//            print("Error")
//        }
//    }
    
    func getDataForSubject(subject: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "subjectName == %@", subject)
            let fetchedResults = try context.fetch(fetchRequest)
            noteArray = fetchedResults
            //            print(noteArray![0].title)
        }
        catch {
            print ("fetch task failed in email", error)
        }
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let imageView = imageView1
        let newImageView = UIImageView(image: imageView?.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        // Your action
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if isEdit {
            let date1 = Date()
            noteArray?[selectedIndex!].setValue(date1.format(), forKey: "date")
            noteArray?[selectedIndex!].setValue(titleTextView.text, forKey: "title")
            noteArray?[selectedIndex!].setValue(noteTextView.text, forKey: "content")
//            noteArray?[selectedIndex!].setValue(userLocation.latitude, forKey: "latitude")
            
            if let imageData = imageView1.image{
                noteArray?[selectedIndex!].setValue(UIImagePNGRepresentation(imageData), forKey: "contentImage")
            }
            
//            noteArray?[selectedIndex!].setValue(userLocation.longitude, forKey: "longitude")
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        }else{
//            let locManager = CLLocationManager()
//            locManager.requestWhenInUseAuthorization()
//            var currentLocation: CLLocation!
//
//            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
//
//                currentLocation = locManager.location
//
//            }
            let note = Note(context: context)
            let date1 = Date()
//            note.setValue(date.format(), forKey: "date")
            note.date = date1.format()
            note.title = titleTextView.text
            note.content = noteTextView.text
            note.latitude = userLocation.latitude
            note.longitude = userLocation.longitude
            note.subjectId = subject?.subjectId ?? 0
            note.subjectName = subject?.subjectTitle ?? ""
            
            if let imageData = imageView1.image{
                  note.setValue(UIImagePNGRepresentation(imageData), forKey: "contentImage")
            }
          
            print("latitude  ", userLocation.latitude)
            print("logitude  ", userLocation.longitude)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
//        let date = Date()
//
//        print(date.format())
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @IBAction func addImageButtonClicked(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            
            //here is the image
        /*
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
            
            */
//            self.noteTextView.attributedText = attributedString;
            self.imageView1.image = image
            
            
            self.noteTextView.becomeFirstResponder()
        }
    }
    
    @IBAction func locationButtonClicked(_ sender: UIBarButtonItem) {
        if let showMapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowMapViewController") as? ShowMapViewController
        {
            if isEdit {
                // get data from database
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                let note = Note(context: context)
                var location1 = CLLocationCoordinate2D()
                location1.latitude = noteArray?[selectedIndex!].latitude ?? 0
                location1.longitude = noteArray?[selectedIndex!].longitude ?? 0
                
                print("latutude",  location1.latitude)
                print("logi", location1.longitude)
                showMapViewController.location = location1
                print(location1.latitude)
            }else{
                showMapViewController.location = userLocation
            }
            
            self.present(showMapViewController, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
                let note = Note(context: context)
                note.isImp = true
//                sender.image = UIImage(named: "favorite.png")
            }else{
                let note = Note(context: context)
                note.isImp = true
//                sender.image = UIImage(named: "unfavorite.png")
            }
        }
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
extension Date {
    /**
     Formats a Date
     
     - parameters format: (String) for eg dd-MM-yyyy hh-mm-ss
     */
    func format(format:String = "yyyy-MM-dd HH:mm:ss Z") -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, h:mm a"
        
        let dateString = dateFormatterGet.string(from: self)
        
        if let newDate = dateFormatterGet.date(from: dateString) {
            print(dateFormatterPrint.string(from: newDate))
            return dateFormatterPrint.string(from: newDate)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
}
