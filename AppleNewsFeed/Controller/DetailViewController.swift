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
    
    @IBOutlet weak var segmentLabelResult: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameString
        descriptionTextView.text = descriptionString
        characterImageView.image = images
        segmentLabelResult.text = seriesString
        
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
        newCharacter.seriesText = seriesString
        newCharacter.comicsText = comicsString
        newCharacter.storiesText = storiesString
        guard let data = characterImageView?.image!.pngData() else{return}
            if !data.isEmpty {
                newCharacter.image = data
            }

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
