//
//  SavedNewsTableViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 11/08/2021.
//

import UIKit
import CoreData


class SavedCharacterListViewController: UITableViewController, ChangeCharacterDelegate {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    var find = FindCharacterController()
    
    
    @IBOutlet weak var editButtonTitle: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()
        countItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        countItems()
    }
    
    func deleteData(){
        do {
            try context?.save()
            basicAlert(title: "Deleted!", message: "Oops you just erased from CoreData your saved character.")
        } catch {
            print(error.localizedDescription)
        }
        loadData()
    }
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "nameText", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        do {
            savedItems = try (context?.fetch(request))!
            
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Saved Items")
        }
        tableView.reloadData()
    }
    
    func countItems() {
        let itemsInTable = String(self.tableView.numberOfRows(inSection: 0))
        self.title = "Saved(\(itemsInTable))"
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        basicAlert(title: "Saved Character Info!", message: "In this section you will find your saved characters.\n You can search in your saved character list by using the Magnifying glass icon in TabBar and typing the character name.\n The character list can be refreshed after search, by using the Refresh icon in TabBar.\n If you decide to delete some of them, you can do it by using \"Edit\" button and click on delete symbol, or alternative way is to pointer on related character and swipe from right side the left, then press \"delete\"!")
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing {
            editButtonTitle.title = "Save"
        }else{
            editButtonTitle.title = "Edit"
        }
    }
    
    func userEnterCharacterName(character: String){
        print(character)
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        request.predicate = NSPredicate(format: "nameText CONTAINS[c] %@", character)
        
        do{
            savedItems = try (context?.fetch(request))!
            tableView.reloadData()
            
        } catch {
            fatalError("Error in searching Saved Items")
        }
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "character" {
            let vc = segue.destination as! FindCharacterController
            vc.delegate = self
        }
    }
    
    @IBAction func refreshSavedItems(_ sender: Any) {
        loadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedCharCell", for: indexPath) as? CharacterListTableViewCell else {
            return UITableViewCell()
        }
        
        let item = savedItems[indexPath.row]
        cell.characterNameLabel.text = item.nameText
        cell.characterNameLabel.numberOfLines = 0
        
        if let imageData = item.image {
            cell.characterImageView.image = UIImage(data: imageData as Data)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard  let destination = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        else {
            return
        }
        let resultName = savedItems[indexPath.row].nameText
        let resultDescription = savedItems[indexPath.row].descriptionText
        let resultSeries = savedItems[indexPath.row].seriesText
        let resultComics = savedItems[indexPath.row].comicsText
        let resultStories = savedItems[indexPath.row].storiesText
        let poster = savedItems[indexPath.row].image
        destination.descriptionString = (resultDescription!)
        destination.nameString = (resultName!)
        destination.images = UIImage(data: poster!)!
        destination.seriesString = (resultSeries!)
        destination.comicsString = (resultComics!)
        destination.storiesString = (resultStories!)
        self.title = "Saved"
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                let item = self.savedItems[indexPath.row]
                self.context?.delete(item)
                self.deleteData()
            }))
            self.present(deleteAlert, animated: true)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let row = savedItems.remove(at: fromIndexPath.row)
        savedItems.insert(row, at: to.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
}


