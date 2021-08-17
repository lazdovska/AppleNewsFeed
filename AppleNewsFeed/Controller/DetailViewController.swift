//
//  DetailViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 11/08/2021.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    var nameString = String()
    var descriptionString = String()
    var charImage: UIImage?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var savedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameString
        descriptionTextView.text = descriptionString
        characterImageView.image = charImage
        //newsImageView.sizeThatFits(250)
        
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
        
        guard let imageData: Data = charImage?.pngData() else {
            return
        }
        
    if !imageData.isEmpty {
    newCharacter.image = imageData
    }
    self.savedItems.append(newCharacter)
    saveData()
        
    }

}
