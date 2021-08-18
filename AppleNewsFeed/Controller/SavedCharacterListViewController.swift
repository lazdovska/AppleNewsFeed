//
//  SavedNewsTableViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 11/08/2021.
//

import UIKit
import CoreData


class SavedCharacterListViewController: UITableViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    // var webURLStringForSource = Int()
    var webURLString = String()
    
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
        basicAlert(title: "Saved Character Info!", message: "In this section you will find your saved characters. If you decide to delete some of them, you can do it by using \"Edit\" button and click on delete symbol, or alternative way is to pointer on related character and swipe from right side the left, then press \"delete\"!")
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing {
            editButtonTitle.title = "Save"
        }else{
            editButtonTitle.title = "Edit"
        }
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
        
       // if let image = UIImage(data: item.image!) {
        //    cell.characterImageView.image = image
       // }
        
        
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


