//
//  NewsFeedViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 09/08/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Gloss

class CharacterListViewController: UIViewController {
    
    var items: [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Marvel Characters"
        activityIndicatorView.isHidden = true
    }
    
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated{
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction func infoBarItem(_ sender: Any) {
        basicAlert(title: "Marvel Character Info!", message: "Press plane to fetch Marvel Characters.")
    }
    
    @IBAction func getDataTapped(_ sender: Any) {
        self.activityIndicator(animated: true)
        handleGetData()
        
    }
    
    func handleGetData(){
        let jsonUrl = "https://gateway.marvel.com:443/v1/public/characters?name=Captain%20America&orderBy=name&ts=1&apikey=70ba4f388906d13bd576ffb400428920&hash=98096b3587d12a61474d31b900eb831e"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, err in
            
            if let err = err {
                self.basicAlert(title: "Error!", message: "\(err.localizedDescription)")
            }
            guard let data = data else{
                self.basicAlert(title: "Error!", message: "Something went wrong, no data")
                return
            }
            do{
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    print("dictData", dictData)
                    self.populateData(dictData)
                }
            }catch{
            }
        }
        task.resume()
    }
    //#warning("Funcion shows error - Cannot convert value of type '[SwiftyJSON.JSON]' to expected argument type '[Gloss.JSON]' (aka 'Array<Dictionary<String, Any>>').")
    func populateData(_ dict:[String: Any]){
        guard let responseDict = dict["results"] as? [Gloss.JSON] else{
            return
        }
        
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator(animated: false)
        }
    }
}

//Mark: UITableViewDelegate, UITableViewDataSource
extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterList", for: indexPath) as? CharacterListTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.characterNameLabel.text = item.name
        cell.characterNameLabel.numberOfLines = 0
        
        if let image = item.thumbnail{
            cell.characterImageView.image = image
        }
        let titleInList = String(item.id.prefix(10))
        self.title = "Avengers \(titleInList)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard  let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        else {
            return
        }
        let item = items[indexPath.row]
        vc.descriptionString = item.description
        vc.nameString = item.name
        vc.charImage = item.thumbnail
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

