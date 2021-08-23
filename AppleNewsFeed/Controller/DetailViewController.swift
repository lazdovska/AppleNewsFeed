//
//  DetailViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 11/08/2021.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var savedItems: [Items] = []
    var context: NSManagedObjectContext?
    var comics: [ComicsItem] = []
    var stories: [StoriesItem] = []
    var series: [Result]? = []
    var imageString = Image.createImage()
    
    var nameString = String()
    var descriptionString = String()
    var images = UIImage()
    var seriesString = String()
    var comicsString = String()
    var storiesString = String()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var savedButton: UIButton!
    
    @IBOutlet weak var charSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var segmentLabelResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameString
        descriptionTextView.text = descriptionString
        characterImageView.image = images
        segmentLabelResult.text = seriesString
        segmentLabelResult.text = comicsString
        segmentLabelResult.text = storiesString
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

    }
    
    func saveData(){
        do {
            try context?.save()
            basicAlert(title: "Saved!", message: "To see your saved characters go to Saved tab bar.")
        } catch {
            print(error.localizedDescription)
        }
    }
   
    @IBAction func savedButtonTapped(_ sender: Any) {
        
        let newCharacter = Items(context: self.context!)
        newCharacter.nameText = nameString
        newCharacter.descriptionText = descriptionString
        
       // guard let imageData: String = imageString?.text else {
         //               return}
         //           if !imageData.isEmpty {
          //          newCharacter.image = imageData
           //         }
        self.savedItems.append(newCharacter)
        saveData()
        
    }

    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        let seriesResult = seriesString
        let comicsResult = comicsString
        let storiesResult = storiesString
            switch charSegmentControl.selectedSegmentIndex
            {
            case 0:
                segmentLabelResult.text = "\(seriesResult)"
            case 1:
                segmentLabelResult.text = "\(comicsResult)"
            case 2:
                segmentLabelResult.text = "\(storiesResult)"
            default:
                break
            }
        }
}
