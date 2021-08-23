//
//  NewsFeedViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 09/08/2021.
//

import UIKit
import CoreLocation
import Gloss

class CharacterListViewController: UIViewController {
    
    var results: [Result]? = []
    var image = Image.createImage()
    var find = FindCharacterController()
    
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
        let jsonUrl = "https://gateway.marvel.com:443/v1/public/characters?series=Avengers%209085%2C%2022547%2C%2024229&orderBy=name&ts=1&apikey=70ba4f388906d13bd576ffb400428920&hash=98096b3587d12a61474d31b900eb831e"
            
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
                    let jsonData = try JSONDecoder().decode(Marvel.self, from: data)
                                        
                    DispatchQueue.main.async {
                        self.results = jsonData.data?.results
                        print("Marvel JSON self.results: ", self.results as Any)
                        self.tableView.reloadData()
                        self.activityIndicator(animated: false)
                    }
                    
                }catch{
                    print("err:", error)
                }
            }
            task.resume()
        }
}

//Mark: UITableViewDelegate, UITableViewDataSource
extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterList", for: indexPath) as? CharacterListTableViewCell else {
            return UITableViewCell()
        }
        
        let result = results?[indexPath.row]
                let poster = results?[indexPath.row]
                cell.characterNameLabel.text = result?.name
                cell.characterNameLabel.numberOfLines = 0
                cell.characterImageView?.image = UIImage(named: (poster?.name)!)
        self.title = "Avengers"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    func updateCharacterData() -> Any{
            if find.characterTextField.isEditing{
                do{
                    handleGetData()
        }
            }
            return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard  let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        else {
            return
        }
        let result = results?[indexPath.row]
        let poster = results?[indexPath.row]
        vc.descriptionString = (result?.resultDescription)!
        vc.nameString = (result?.name)!
        vc.images = UIImage(named: (poster?.name)!)!
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

